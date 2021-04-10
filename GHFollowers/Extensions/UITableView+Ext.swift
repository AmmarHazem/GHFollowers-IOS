//
//  UITableView+Ext.swift
//  GHFollowers
//
//  Created by Ammar on 07/03/2021.
//

import UIKit


extension UITableView {
    
    func removeExcessCells() {
        self.tableFooterView = UIView(frame: .zero)
    }
}
