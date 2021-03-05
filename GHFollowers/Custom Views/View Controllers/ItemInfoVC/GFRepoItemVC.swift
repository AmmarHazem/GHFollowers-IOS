//
//  GFRepoItemVC.swift
//  GHFollowers
//
//  Created by Ammar on 20/02/2021.
//

import UIKit
import SafariServices


class GFRepoItemVC: GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureItems()
    }
    
    
    private func configureItems() {
        itemInfoViewOne.set(itemType: .repos, withCount: "\(self.user.publicRepos)")
        itemInfoViewTwo.set(itemType: .gists, withCount: "\(self.user.publicGists)")
        actionButton.set(background: .systemPurple, title: "Github Profile")
    }
    
    
    override func actionButtonPressed() {
        self.userInfoVCDelegate?.didTapGithubProfileButton(forUser: self.user)
    }
}
