//
//  GFTabBarController.swift
//  GHFollowers
//
//  Created by Ammar on 27/02/2021.
//

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UINavigationBar.appearance().tintColor = .systemGreen
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [createSearchNC(), createFavouritesNC()]
    }
    
    
    func createSearchNC() -> UINavigationController {
        let searchVC = SearchVC()
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        return UINavigationController(rootViewController: searchVC)
    }
    
    
    func createFavouritesNC() -> UINavigationController {
        let favouritesVC = FavouritesListVC()
        favouritesVC.title = "Favourites"
        favouritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        return UINavigationController(rootViewController: favouritesVC)
    }

}
