//
//  GFUserInfoHeaderVC.swift
//  GHFollowers
//
//  Created by Ammar on 18/02/2021.
//

import UIKit

class GFUserInfoHeaderVC: UIViewController {

    
    private let avatarImgView = GFAvatarImageView(frame: .zero)
    private let usernameLabel = GHTitleLabel(textAlignment: .left, fontSize: 34)
    private let nameLabel = GFSecondaryLabel(fontSize: 18)
    private let locationImgView = UIImageView(image: UIImage(systemName: SFSymbols.location))
    private let locationLabel = GFSecondaryLabel(fontSize: 18)
    private let bioLabel = GFBodyLabel(textAlignment: .left)
    var user: User!
    
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        layoutUI()
        configureUIElements()
    }
    
    
    private func addSubviews() {
        view.addSubview(avatarImgView)
        view.addSubview(usernameLabel)
        view.addSubview(nameLabel)
        view.addSubview(locationLabel)
        view.addSubview(locationImgView)
        view.addSubview(locationLabel)
        view.addSubview(bioLabel)
    }
    
    
    private func layoutUI() {
        let padding: CGFloat = 20
        let textImgPadding: CGFloat = 12
        
        locationImgView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImgView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            avatarImgView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            avatarImgView.heightAnchor.constraint(equalToConstant: 90),
            avatarImgView.widthAnchor.constraint(equalToConstant: 90),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImgView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImgView.trailingAnchor, constant: textImgPadding),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 38),
            
            nameLabel.centerYAnchor.constraint(equalTo: avatarImgView.centerYAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImgView.trailingAnchor, constant: textImgPadding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 38),
            
            locationImgView.bottomAnchor.constraint(equalTo: avatarImgView.bottomAnchor),
            locationImgView.leadingAnchor.constraint(equalTo: avatarImgView.trailingAnchor, constant: textImgPadding),
            locationImgView.widthAnchor.constraint(equalToConstant: 20),
            locationImgView.heightAnchor.constraint(equalToConstant: 20),
            
            locationLabel.leadingAnchor.constraint(equalTo: locationImgView.trailingAnchor, constant: 5),
            locationLabel.centerYAnchor.constraint(equalTo: locationImgView.centerYAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            locationLabel.heightAnchor.constraint(equalToConstant: 20),
            
            bioLabel.topAnchor.constraint(equalTo: avatarImgView.bottomAnchor, constant: textImgPadding),
            bioLabel.leadingAnchor.constraint(equalTo: avatarImgView.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            bioLabel.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    
    private func configureUIElements() {
        if let imgURL = user.avatarUrl {
            avatarImgView.downloadImage(from: imgURL)
        }
        usernameLabel.text = user.login
        nameLabel.text = user.name
        locationLabel.text = user.location ?? "No Location"
        bioLabel.text = user.bio
        bioLabel.numberOfLines = 3
        locationImgView.tintColor = .secondaryLabel
    }
    
}
