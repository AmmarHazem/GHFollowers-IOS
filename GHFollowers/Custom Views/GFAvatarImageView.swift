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
        networkManager.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            self.image = image
        }
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
