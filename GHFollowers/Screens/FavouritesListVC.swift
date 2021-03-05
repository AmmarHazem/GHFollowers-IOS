//
//  FavouritesListVC.swift
//  GHFollowers
//
//  Created by Ammar on 2/7/21.
//

import UIKit

class FavouritesListVC: GFDataLoadingVC {

    
    //MARK: - Constants and Variables
    private let tableView = UITableView()
    private let emptyStateMessage = "No favourites added yet!"
    private var favourites = [Follower]()
    
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        configureVC()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getFavourites()
    }
    
    
    //MARK: - Custom Methods
    private func configureVC() {
        view.backgroundColor = .systemBackground
        title = "Favourites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavouritesCell.self, forCellReuseIdentifier: FavouritesCell.reuseID)
    }
    
    
    private func getFavourites() {
        PersistenceManager.getFavourites { (result) in
            switch result {
            case .success(let favourites):
                
                if favourites.isEmpty {
                    self.showEmptyStateView(with: emptyStateMessage, in: self.view)
                    self.tableView.isHidden = true
                    return
                }

                self.favourites = favourites
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
                break
            case .failure(let error):
                self.presentGFAlert(title: "Error", message: error.rawValue, buttonTitle: "OK")
                break
            }
        }
    }

}


extension FavouritesListVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favourites.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavouritesCell.reuseID) as! FavouritesCell
        cell.set(forFavourite: favourites[indexPath.item])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = favourites[indexPath.item]
        let followerListVC = FollowersListVC(username: user.login)
//        followerListVC.username = user.login
//        followerListVC.title = user.login
        navigationController?.pushViewController(followerListVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle != .delete { return }
        let user = favourites[indexPath.item]
        favourites.remove(at: indexPath.item)
        tableView.deleteRows(at: [indexPath], with: .left)
        if favourites.isEmpty {
            tableView.isHidden = true
            self.showEmptyStateView(with: emptyStateMessage, in: self.view)
        }
        
        PersistenceManager.updateWith(favourite: user, action: .remove) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.presentGFAlert(title: "Error", message: error.rawValue, buttonTitle: "OK")
                return
            }
        }
    }
    
}
