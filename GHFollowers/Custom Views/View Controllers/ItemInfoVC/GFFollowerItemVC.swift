//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by Ammar on 20/02/2021.
//

import UIKit


class GFFollowerItemVC: GFItemInfoVC {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureItems()
    }
    
    
    private func configureItems() {
        itemInfoViewOne.set(itemType: .followers, withCount: "\(self.user.followers)")
        itemInfoViewTwo.set(itemType: .following, withCount: "\(self.user.following)")
        actionButton.set(background: .systemGreen, title: "Get Followers")
    }
    
    
    override func actionButtonPressed() {
        self.userInfoVCDelegate?.didTapGetFollowersButton(forUser: self.user)
    }
}
