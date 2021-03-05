//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Ammar on 17/02/2021.
//

import UIKit


protocol UserInfoVCDelegate: class {
    func didTapGithubProfileButton(forUser user: User)
    func didTapGetFollowersButton(forUser user: User)
}


class UserInfoVC: GFDataLoadingVC {

    
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    var username: String!
    weak var followerListVCDelegate: FollowerListVCDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureVC()
        layoutUI()
        getUserInfo()
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
        let navbarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.setRightBarButtonItems([navbarButton], animated: true)
    }
    
    
    private func layoutUI() {
        view.addSubview(headerView)
        view.addSubview(itemViewOne)
        view.addSubview(itemViewTwo)
        view.addSubview(dateLabel)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        itemViewOne.translatesAutoresizingMaskIntoConstraints = false
        itemViewTwo.translatesAutoresizingMaskIntoConstraints = false

        let padding: CGFloat = 20
        let cardItemHeight: CGFloat = 140
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemViewOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: cardItemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemViewTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: cardItemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    
    private func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                print("--- fetch user success")
                print(user.login)
                self.configureUIElements(forUser: user)
            case .failure(let error):
                print("---- fetch user error")
                print(error.rawValue)
                self.presentGFAlert(title: "Error", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    
    private func configureUIElements(forUser user: User) {
        let repoItemVC = GFRepoItemVC(user: user)
        let followerItemVC = GFFollowerItemVC(user: user)
        repoItemVC.userInfoVCDelegate = self
        followerItemVC.userInfoVCDelegate = self
        self.dateLabel.text = "Github since \(user.createdAt.convertToMonthYearFormat())"
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.add(childVC: repoItemVC, to: self.itemViewOne)
        self.add(childVC: followerItemVC, to: self.itemViewTwo)
    }
    
    
    private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }

}


extension UserInfoVC: UserInfoVCDelegate {
    
    
    func didTapGithubProfileButton(forUser user: User) {
        if let url = user.htmlUrl {
            self.presentSafariVC(withURL: url)
        }
    }
    
    
    func didTapGetFollowersButton(forUser user: User) {
        if user.followers == 0 {
            presentGFAlert(title: "No Followers", message: "This user has no followers yet!", buttonTitle: "OK")
            return
        }
        dismiss(animated: true) { self.followerListVCDelegate?.didRequestFollowers(forUsername: user.login) }
    }
    
    
}
