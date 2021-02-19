//
//  FollowersListVC.swift
//  GHFollowers
//
//  Created by Ammar on 12/02/2021.
//

import UIKit

class FollowersListVC: UIViewController {
    
    enum Section { case main }
    
    //MARK: - Variables and Constants
    var username: String!
    private var followers = [Follower]()
    private var filteredFollowers = [Follower]()
    private var collectionView: UICollectionView!
    private var collectionViewDataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    private var currentPage = 1
    private var hasMoreFollowers = false
    private var isSearching = false
    

    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureCollectionView()
        configureDataSource()
        configureSearchController()
        getFollowers()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    //MARK: - Custom Methods
    private func configureViewController() {
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: configureCollectionViewLayout())
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
        self.view.addSubview(collectionView)
    }
    
    
    private func configureCollectionViewLayout() -> UICollectionViewFlowLayout {
        let width = self.view.bounds.width
        let padding: CGFloat = 12
        let rowWidth = width - (4 * padding)
        let cellWidth = rowWidth / 3
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        collectionViewLayout.itemSize = CGSize(width: cellWidth, height: cellWidth + 40)
        return collectionViewLayout
    }
    
    
    private func configureDataSource() {
        collectionViewDataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username."
        searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
    }
    
    
    private func getFollowers() {
        showLoadingView()
        NetworkManager.shared.getFollowers(for: username, page: currentPage) { [weak self] result in
            self?.removeLoadingView()
            switch result {
                case .success(let followers):
//                    print(followers)
//                    print(followers.count)
//                    self?.followers = followers
                    if followers.count < 100 {
                        self?.hasMoreFollowers = false
                    }
                    else {
                        self?.hasMoreFollowers = true
                    }
                    self?.followers.append(contentsOf: followers)
                    if self?.followers.isEmpty ?? false {
                        self?.showEmptyStateView(with: "This user has no followers.", in: self!.view)
                        return
                    }
                    self?.updateData(followers: self!.followers)
                
                case .failure(let error):
                    self?.presentGFAlert(title: "Error", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    
    private func updateData(followers array: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(array)
        collectionViewDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }

}


//MARK: - Scroll View Delegate
extension FollowersListVC: UICollectionViewDelegate {
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !hasMoreFollowers { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.bounds.height
        
//        print("--- didEndDrag")
//        print(offsetY)
//        print(contentHeight)
//        print(height)
        if offsetY > contentHeight - height {
            currentPage += 1
            getFollowers()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let array = isSearching ? filteredFollowers : followers
        let follower = array[indexPath.item]
        let userInfoVC = UserInfoVC()
        userInfoVC.username = follower.login
        let navigationController = UINavigationController(rootViewController: userInfoVC)
        self.present(navigationController, animated: true, completion: nil)
    }
}


//MARK: - Search Results Updater
extension FollowersListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let filterText = searchController.searchBar.text,
              !filterText.isEmpty else {
            isSearching = false
            filteredFollowers = []
            updateData(followers: followers)
            return
        }
        
        isSearching = true
        filteredFollowers = followers.filter() { $0.login.lowercased().contains(filterText.lowercased()) }
        updateData(followers: filteredFollowers)
    }
    
}
