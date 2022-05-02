//
//  CacheManager.swift
//  StoryUI (iOS)
//
//  Created by Tolga İskender on 30.04.2022.
//

import Foundation

public enum Result<T> {
    case success(T)
    case failure(String)
}

class CacheManager: NSObject {

    static let shared = CacheManager()
    
    private let fileManager = FileManager.default
    private lazy var mainDirectoryUrl: URL = {

        let documentsUrl = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return documentsUrl
    }()

    
    func getFileWith(stringUrl: String, completionHandler: @escaping (Result<URL>) -> Void ) {
        let file = directoryFor(stringUrl: stringUrl)
        //return file path if already exists in cache directory
        guard !fileManager.fileExists(atPath: file.path)  else {
            completionHandler(Result.success(file))
            return
        }

        guard let url = URL(string: stringUrl) else {
            completionHandler(Result.failure("url error"))
            return
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        session.dataTask(with: url, completionHandler: { (data, response, error) in

            if error != nil {
                print(error as Any)
                return
            }
            guard let data = data as? NSData else {
                completionHandler(Result.failure("cache error"))
                return
            }
            data.write(to: file, atomically: true)
            DispatchQueue.main.async {
                completionHandler(Result.success(file))
            }

        }).resume()
    }

    private func directoryFor(stringUrl: String) -> URL {
        let fileURL = URL(string: stringUrl)!.lastPathComponent
        let file = self.mainDirectoryUrl.appendingPathComponent(fileURL)
        return file
    }
}


extension CacheManager: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, urlCredential)
    }
}
