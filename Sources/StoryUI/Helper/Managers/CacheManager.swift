//
//  CacheManager.swift
//  StoryUI (iOS)
//
//  Created by Tolga İskender on 30.04.2022.
//

@preconcurrency import AVFoundation

public enum Result<T> {
    case success(T)
    case failure(String)
}

final class CacheManager: NSObject {

    private let fileManager = FileManager.default

    func loadVideo(from url: URL, completion: @escaping (Result<URL>) -> Void) {
        switch createCacheDirectory() {
        case .success(let cacheDirectory):
            let videoFileName = url.lastPathComponent
            let destinationUrl = cacheDirectory.appendingPathComponent(videoFileName)

            if fileManager.fileExists(atPath: destinationUrl.path) {
                DispatchQueue.main.async {
                    completion(.success(destinationUrl))
                }
            } else {
                downloadAndCacheVideo(from: url, completion: completion)
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

extension FileManager: @unchecked @retroactive Sendable {}

private extension CacheManager {

    func createCacheDirectory() -> Result<URL> {
        guard let cacheDirectory = fileManager.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first
        else {
            return .failure("Unable to get cache directory")
        }

        let videoCacheDirectory = cacheDirectory.appendingPathComponent(
            "VideoCache",
            isDirectory: true
        )

        if !fileManager.fileExists(atPath: videoCacheDirectory.path) {
            do {
                try fileManager.createDirectory(
                    at: videoCacheDirectory,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            } catch {
                return .failure("Error creating video cache directory: \(error.localizedDescription)")
            }
        }

        return .success(videoCacheDirectory)
    }

    func downloadAndCacheVideo(from url: URL, completion: @escaping (Result<URL>) -> Void) {
        let backgroundQueue = DispatchQueue.global(qos: .background)

        backgroundQueue.async { [weak self] in
            let session = URLSession(
                configuration: .default,
                delegate: self,
                delegateQueue: nil
            )
            let task = session.downloadTask(with: url) { [weak self] (tempLocalUrl, response, error) in
                guard let self else { return }

                if let error = error {
                    completion(.failure("Error downloading video: \(error.localizedDescription)"))
                    return
                }

                guard let tempLocalUrl = tempLocalUrl,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200
                else {
                    completion(.failure("Error: Invalid response or no data"))
                    return
                }

                switch self.createCacheDirectory() {
                case .success(let cacheDirectory):
                    let videoFileName = url.lastPathComponent
                    let destinationUrl = cacheDirectory.appendingPathComponent(videoFileName)

                    do {
                        if FileManager.default.fileExists(
                            atPath: destinationUrl.path
                        ) {
                            try FileManager.default.removeItem(at: destinationUrl)
                        }

                        try FileManager.default.moveItem(
                            at: tempLocalUrl,
                            to: destinationUrl
                        )

                        DispatchQueue.main.async {
                            completion(.success(destinationUrl))
                        }

                    } catch {
                        completion(.failure("Error moving video file to cache: \(error.localizedDescription)"))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
}


extension CacheManager: URLSessionDelegate {
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (
            URLSession.AuthChallengeDisposition,
            URLCredential?
        ) -> Void
    ) {
        let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, urlCredential)
    }
}
