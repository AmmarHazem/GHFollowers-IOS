//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Ammar on 21/02/2021.
//

import Foundation


extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM YYYY"
        return dateFormatter.string(from: self)
    }
}
