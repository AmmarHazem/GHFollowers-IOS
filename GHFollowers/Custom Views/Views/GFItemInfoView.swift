//
//  GFItemInfoView.swift
//  GHFollowers
//
//  Created by Ammar on 20/02/2021.
//

import UIKit

class GFItemInfoView: UIView {

    let symbolImgView = UIImageView()
    let titleLabel = GHTitleLabel(textAlignment: .left, fontSize: 14)
    let countLabel = GHTitleLabel(textAlignment: .center, fontSize: 14)
    
    
    init(symbolName: String, title: String, count: String) {
        super.init(frame: .zero)
        symbolImgView.image = UIImage(systemName: symbolName)
        titleLabel.text = title
        countLabel.text = count
        configure()
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        addSubview(symbolImgView)
        addSubview(titleLabel)
        addSubview(countLabel)
        
        symbolImgView.translatesAutoresizingMaskIntoConstraints = false
        symbolImgView.contentMode = .scaleAspectFill
        symbolImgView.tintColor = .label
        
        NSLayoutConstraint.activate([
            symbolImgView.topAnchor.constraint(equalTo: self.topAnchor),
            symbolImgView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            symbolImgView.heightAnchor.constraint(equalToConstant: 20),
            symbolImgView.widthAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: symbolImgView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImgView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            countLabel.topAnchor.constraint(equalTo: symbolImgView.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
    }
    
    
    func set(itemType: ItemInfoType, withCount count: String) {
        countLabel.text = count
        switch itemType {
        case .following:
            symbolImgView.image = UIImage(systemName: SFSymbols.following)
            titleLabel.text = "Following"
        case .followers:
            symbolImgView.image = UIImage(systemName: SFSymbols.followers)
            titleLabel.text = "Followers"
        case .gists:
            symbolImgView.image = UIImage(systemName: SFSymbols.gists)
            titleLabel.text = "Gists"
        case .repos:
            symbolImgView.image = UIImage(systemName: SFSymbols.repos)
            titleLabel.text = "Public Repos"
        }
    }

}


enum ItemInfoType {
    case following
    case followers
    case gists
    case repos
}
