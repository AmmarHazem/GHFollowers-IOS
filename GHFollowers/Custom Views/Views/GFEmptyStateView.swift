//
//  GFEmptyStateView.swift
//  GHFollowers
//
//  Created by Ammar on 17/02/2021.
//

import UIKit

class GFEmptyStateView: UIView {

    
    let messageLabel = GHTitleLabel(textAlignment: .center, fontSize: 28)
    let logoImgView = UIImageView(image: Images.emptyState)
    
    
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
    
    
    private func configure() {
        configureMessagelabel()
        configureLogoImgView()
    }
    
    
    private func configureMessagelabel() {
        addSubview(messageLabel)
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.numberOfLines = 3
        messageLabel.textColor = .secondaryLabel
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let messageLabelCenterYConstant: CGFloat = DeviceTypes.isiPhone8Standard || DeviceTypes.isiPhone8Zoomed ? -110 : -150
        messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: messageLabelCenterYConstant).isActive = true
        
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    
    private func configureLogoImgView() {
        addSubview(logoImgView)
        
        logoImgView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImgView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImgView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImgView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 170),
            logoImgView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 40),
        ])
    }
    
}
