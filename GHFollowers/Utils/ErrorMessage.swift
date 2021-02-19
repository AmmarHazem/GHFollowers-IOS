//
//  ErrorMessage.swift
//  GHFollowers
//
//  Created by Ammar on 14/02/2021.
//

import Foundation


enum GFError: String, Error {
    case networkError = "Network error. Please try again."
    case defaultMessage = "Something went wrong. Please try again."
}
