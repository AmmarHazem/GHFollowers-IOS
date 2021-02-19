//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Ammar on 15/02/2021.
//

import UIKit

class GFAvatarImageView: UIImageView {

    
    private let placeholderImage = UIImage(named: "avatar-placeholder")!
    private let networkManager = NetworkManager.shared
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func getImgFromCache(for key: String) -> UIImage? {
        networkManager.getImageFromCache(with: NSString(string: key))
    }
    
    
    func getAndCacheImg(from url: URL) {
        let task = URLSession(configuration: .default).dataTask(with: url) { [weak self] data, response, error in
            if error != nil { return }
            guard let response = response as? HTTPURLResponse,
                  response.statusCode >= 200 && response.statusCode < 300,
                  let data = data
            else { return }
            guard let image = UIImage(data: data) else { return }
            self?.networkManager.addImageToCache(image, forKey: NSString(string: url.absoluteString), cost: data.count)
            DispatchQueue.main.async { self?.image = image }
        }
        task.resume()
    }
    
    
    func downloadImage(from urlStr: String) {
        if let image = getImgFromCache(for: urlStr) {
            self.image = image
            return
        }
        image = placeholderImage
        guard let url = URL(string: urlStr) else { return }
        
        getAndCacheImg(from: url)
    }
    
    
    func downloadImage(from url: URL) {
        if let image = getImgFromCache(for: url.absoluteString) {
            self.image = image
            return
        }
        image = placeholderImage
        
        getAndCacheImg(from: url)
    }

}
