//
//  GFDataLoadingVC.swift
//  GHFollowers
//
//  Created by Ammar on 28/02/2021.
//

import UIKit

class GFDataLoadingVC: UIViewController {
    
    
    var containerView: UIView?
    

    func presentGFAlert(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alert = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alert.modalPresentationStyle = .overFullScreen
            alert.modalTransitionStyle = .crossDissolve
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func showLoadingView() {
        containerView = UIView(frame: view.frame)
        view.addSubview(containerView!)
        
        
        containerView?.backgroundColor = .systemBackground
        containerView?.alpha = 0.0
        
        UIView.animate(withDuration: 0.7) { self.containerView?.alpha = 0.8 }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView?.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: containerView!.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView!.centerYAnchor),
        ])
        activityIndicator.startAnimating()
    }
    
    
    func removeLoadingView() {
        containerView?.removeFromSuperview()
        containerView = nil
    }
    
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GFEmptyStateView(message: message)
        view.addSubview(emptyStateView)
        emptyStateView.frame = view.bounds
    }

}
