//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by Ammar on 13/02/2021.
//

import UIKit
import SafariServices


extension UIViewController {
    
    
    func presentSafariVC(withURL url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        self.present(safariVC, animated: true, completion: nil)
    }
}
