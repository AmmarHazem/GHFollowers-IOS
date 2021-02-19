//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Ammar on 17/02/2021.
//

import UIKit

class UserInfoVC: UIViewController {

    
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    var username: String!
    
    
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
        
        itemViewOne.backgroundColor = .systemRed
        itemViewTwo.backgroundColor = .systemBlue
        
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
        ])
    }
    
    
    private func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { result in
            switch result {
            case .success(let user):
                print("--- fetch user success")
                print(user.login)
                self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
            case .failure(let error):
                print("---- fetch user error")
                print(error.rawValue)
                self.presentGFAlert(title: "Error", message: error.rawValue, buttonTitle: "OK")
            }
        }
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
