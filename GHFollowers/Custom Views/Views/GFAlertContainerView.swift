//
//  GFAlertContainerView.swift
//  GHFollowers
//
//  Created by Ammar on 13/02/2021.
//

import UIKit

class GFAlertContainerView: UIView {

    
    init() {
        super.init(frame: .zero)
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
        self.backgroundColor = .systemBackground
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
