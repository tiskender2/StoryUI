//
//  ImageLoader.swift
//  StoryUI
//
//  Created by Tolga İskender on 28.03.2022.
//

import Combine
import UIKit

final class ImageLoader: UIView {
    
    // MARK: Public Properties
    var imageURL: URL?
    var imageView = UIImageView()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
     // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        setupImageView()
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

        guard let imageURL else { return }

        imageView.image = nil
        // stop video if it's playing before image request
        NotificationCenter.default.post(name: .stopVideo, object: nil)

        if let cachedResponse = URLCache.shared.cachedResponse(for: .init(url: imageURL)) {
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image =  UIImage(data: cachedResponse.data)
                imageIsLoaded()
            }
            return
        }

        addIndicator()

        URLSession.shared.dataTask(
            with: imageURL,
            completionHandler: { [weak self] (data, response, error) in
            guard let self else { return }
            if error != nil {
                print(error as Any)
                return
            }

            guard let data,
                  let response,
                  let image = UIImage(data: data)
            else { return }

            URLCache.shared.storeCachedResponse(
                .init(response: response, data: data),
                for: .init( url: imageURL)
            )

            DispatchQueue.main.async {
                self.imageView.image = image
                imageIsLoaded()
                self.activityIndicator.stopAnimating()
            }
        }).resume()
    }

}
// MARK: - Private Funcs
private extension ImageLoader {
   func setupImageView() {
       self.addSubview(imageView)
       imageView.layer.cornerRadius = 12
       imageView.clipsToBounds = true
   }
}
// MARK: - Const funcs
extension ImageLoader {
    
    private func addConst() {
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
