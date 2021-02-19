//
//  SearchVC.swift
//  GHFollowers
//
//  Created by Ammar on 2/7/21.
//

import UIKit

class SearchVC: UIViewController {
    
    //MARK: - Vars and Constants
    let logoImgView = UIImageView()
    let usernameTextField = GFTextField()
    let callToActionButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers")

    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.text = "SAllen0400"
        
        view.backgroundColor = .systemBackground
        configureLogoImgView()
        configureUsernameTextField()
        configureCallToActionButton()
        createDismissKeyboardTabGesture()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    //MARK: - UI Configuration
    func configureLogoImgView() {
        view.addSubview(logoImgView)
        logoImgView.translatesAutoresizingMaskIntoConstraints = false
        logoImgView.image = UIImage(named: "gh-logo")
        
        NSLayoutConstraint.activate([
            logoImgView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImgView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            logoImgView.heightAnchor.constraint(equalToConstant: 200),
            logoImgView.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    
    func configureUsernameTextField() {
        self.view.addSubview(usernameTextField)
        usernameTextField.delegate = self
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImgView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    
    func configureCallToActionButton() {
        self.view.addSubview(callToActionButton)
        callToActionButton.addTarget(self, action: #selector(pushFollowersListVC), for: .touchUpInside)
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            callToActionButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    //MARK: - Custom Methods
    @objc func pushFollowersListVC() {
        guard let username = usernameTextField.text, !username.isEmpty else {
            presentGFAlert(title: "No username entered", message: "Please enter a username. We need to know how to look for 😃", buttonTitle: "OK")
            return
        }
        usernameTextField.resignFirstResponder()
        let followerListVC = FollowersListVC()
        followerListVC.username = username
        followerListVC.title = username
        self.navigationController?.pushViewController(followerListVC, animated: true)
    }
    
    
    func createDismissKeyboardTabGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        self.view.addGestureRecognizer(tap)
    }
}

//MARK: - Text Field Delegate
extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowersListVC()
        return true
    }
}
