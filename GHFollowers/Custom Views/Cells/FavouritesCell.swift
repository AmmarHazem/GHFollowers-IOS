//
//  FavouritesCell.swift
//  GHFollowers
//
//  Created by Ammar on 23/02/2021.
//

import UIKit

class FavouritesCell: UITableViewCell {

    static let reuseID = "FavouriteCell"
    let avatarImgView = GFAvatarImageView(frame: .zero)
    let usernameLabel = GHTitleLabel(textAlignment: .left, fontSize: 26)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        addSubview(avatarImgView)
        addSubview(usernameLabel)
        
        accessoryType = .disclosureIndicator
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            avatarImgView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarImgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            avatarImgView.heightAnchor.constraint(equalToConstant: 60),
            avatarImgView.widthAnchor.constraint(equalToConstant: 60),
            
            usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImgView.trailingAnchor, constant: 24),
            usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    
    func set(forFavourite favourite: Follower) {
        usernameLabel.text = favourite.login
        avatarImgView.downloadImage(from: favourite.avatarUrl)
    }
    
}
