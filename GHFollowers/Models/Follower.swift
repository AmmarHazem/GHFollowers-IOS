//
//  Follower.swift
//  GHFollowers
//
//  Created by Ammar on 14/02/2021.
//

import Foundation


struct Follower: Decodable, Hashable {
    let login: String
    let avatarUrl: String
}
