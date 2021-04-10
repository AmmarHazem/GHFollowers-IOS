//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by Ammar on 21/02/2021.
//

import Foundation


enum PersistenceActionType {
    case add, remove
}


enum PersistenceManager {
    
    enum Keys { static let favourites = "favourites" }


    static private let userDefaults = UserDefaults.standard
    
    
    static func toggleFavourite(user: Follower, completed: (GFError?) -> Void) {
        let favouritesJsonData = userDefaults.object(forKey: Keys.favourites) as? Data ?? Data()
        var favourites = (try? JSONDecoder().decode([Follower].self, from: favouritesJsonData)) ?? []
        
        if let user = favourites.first(where: { $0.login == user.login }) {
            favourites.removeAll() { $0.login == user.login }
            let updatedFavouritesJsonData = try? JSONEncoder().encode(favourites)
            userDefaults.setValue(updatedFavouritesJsonData, forKey: Keys.favourites)
            print("--- toggle success remove")
        }
        else {
            favourites.append(user)
            let updatedFavouritesJsonData = try? JSONEncoder().encode(favourites)
            userDefaults.setValue(updatedFavouritesJsonData, forKey: Keys.favourites)
            print("--- toggle success add")
        }
        completed(nil)
    }
    
    
    static func updateWith(favourite: Follower, action type: PersistenceActionType, completed: (GFError?) -> Void) {
        getFavourites { result in
            switch result {
            case .success(var favourites):
                
                switch type {
                case .add:
                    if favourites.contains(favourite) {
                        completed(.alreadyAddedToFavourites)
                        return
                    }
                    favourites.append(favourite)
                case .remove:
                    favourites.removeAll { $0.login == favourite.login }
                }
                
                completed(save(favourites: favourites))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    
    static func getFavourites(completed: (Result<[Follower], GFError>) -> Void) {
        
        guard let favouritesData = userDefaults.object(forKey: Keys.favourites) as? Data else {
            print("--- get favourites error 1")
            completed(.success([]))
            return
        }
        
        let jsonDecoder = JSONDecoder()
        let favourites = try? jsonDecoder.decode([Follower].self, from: favouritesData)
        if let favourites = favourites {
            completed(.success(favourites))
        }
        else {
            completed(.failure(.defaultMessage))
        }
    }
    
    
    static func save(favourites: [Follower]) -> GFError? {
        
        let jsonEncoder = JSONEncoder()
        let favouritesEncodedJsonData = try? jsonEncoder.encode(favourites)
        if let jsonData = favouritesEncodedJsonData {
            userDefaults.set(jsonData, forKey: Keys.favourites)
            return nil
        }
        else {
            return .defaultMessage
        }
    }
}
