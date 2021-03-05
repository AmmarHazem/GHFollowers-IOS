//
//  GFEmptyStateView.swift
//  GHFollowers
//
//  Created by Ammar on 17/02/2021.
//

import UIKit

class GFEmptyStateView: UIView {

    
    let messageLabel = GHTitleLabel(textAlignment: .center, fontSize: 28)
    let logoImgView = UIImageView(image: UIImage(named: "empty-state-logo"))
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }
    
    
    func configure() {
        addSubview(messageLabel)
        addSubview(logoImgView)
        
        messageLabel.numberOfLines = 3
        messageLabel.textColor = .secondaryLabel
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        logoImgView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -150),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),
            
            logoImgView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImgView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImgView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 170),
            logoImgView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 40),
        ])
    }
    
}
