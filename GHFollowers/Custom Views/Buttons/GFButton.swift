//
//  GFButton.swift
//  GHFollowers
//
//  Created by Ammar on 11/02/2021.
//

import UIKit

class GFButton: UIButton {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(backgroundColor: UIColor, title: String) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
    }
    
    
    private func configure() {
        self.layer.cornerRadius = 10
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func set(background color: UIColor, title: String) {
        self.backgroundColor = color
        self.setTitle(title, for: .normal)
        configure()
    }
}
