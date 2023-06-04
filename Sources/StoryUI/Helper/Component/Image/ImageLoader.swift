//
//  ImageLoader.swift
//  StoryUI
//
//  Created by Tolga İskender on 28.03.2022.
//

import Combine
import UIKit

class ImageLoader: UIView {
    
    // MARK: Public Properties
    var imageURL: URL?
    var imageView = UIImageView()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
     // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        self.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addConst()
    }
    
    func loadImageWithUrl(_ url: String?, imageIsLoaded: @escaping () -> Void) {
       
        guard let validatedUrl = url else {
            print("url error")
            return
        }
        
        if imageURL == URL(string: validatedUrl) {
            return
        }
        
        imageURL = URL(string: validatedUrl)
        
        guard let imageURL = imageURL else {
            return
        }

        imageView.image = nil
        // stop video if it's playing before image request
        NotificationCenter.default.post(name: .stopVideo, object: nil)
        // retrieves image if already available in cache
        if let imageFromCache = ImageCacheKey.imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.imageView.image = imageFromCache
            imageIsLoaded()
            return
        }
        
        addIndicator()
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        session.dataTask(with: imageURL, completionHandler: { [weak self] (data, response, error) in
            guard let self = self else { return }
            if error != nil {
                print(error as Any)
                return
            }

            DispatchQueue.main.async(execute: {
                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {

                    if self.imageURL == URL(string: validatedUrl) {
                        self.imageView.image = imageToCache
                        imageIsLoaded()
                    }
                    ImageCacheKey.imageCache.setObject(imageToCache, forKey: url as AnyObject)
                }
                self.activityIndicator.stopAnimating()
            })
        }).resume()
    }
    
    fileprivate func addConst() {
        imageView.frame.size.width = self.frame.size.width
        imageView.frame.size.height = self.frame.size.height
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 0),
            imageView.rightAnchor.constraint(equalTo: self.rightAnchor,constant: 0),
            imageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,constant: 0),
            imageView.topAnchor.constraint(equalTo: self.topAnchor,constant: 0),
        ])
    }
    
    private func addIndicator() {
        activityIndicator.color = UIColor.lightGray.withAlphaComponent(0.7)
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.startAnimating()
    }
}
extension ImageLoader: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, urlCredential)
    }
}
