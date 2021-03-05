//
//  String+Ext.swift
//  GHFollowers
//
//  Created by Ammar on 21/02/2021.
//

import Foundation


extension String {
    
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = .current
        dateFormatter.timeZone = .current
        return dateFormatter.date(from: self)
    }
}
