//
//  FollowersListVC.swift
//  GHFollowers
//
//  Created by Ammar on 12/02/2021.
//

import UIKit


protocol FollowerListVCDelegate: class {
    func didRequestFollowers(forUsername username: String)
}


class FollowersListVC: GFDataLoadingVC {
    
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
    private var isFavourite = false
    private var isLoadingFollowers = false
    
    
    //MARK: - Initializers
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

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
        getIsFavouriteState()
    }
    
    
    //MARK: - Custom Methods
    
    private func getIsFavouriteState() {
        PersistenceManager.getFavourites { result in
            switch result {
            case .success(let favourites):
                favourites.forEach { user in
                    if user.login == self.username {
                        self.isFavourite = true
                    }
                    else {
                        self.isFavourite = false
                    }
                }
            case .failure(_):
                break
            }
            self.configureFavouritesButton()
            print("--- favourite state \(self.isFavourite)")
        }
    }
    
    
    private func configureViewController() {
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = username
    }
    
    
    private func configureFavouritesButton() {
        var buttonIcon: UIImage!
        if isFavourite {
            buttonIcon = SFSymbols.heartFill
        }
        else {
            buttonIcon = SFSymbols.followers
        }
        let addToFavouriteBarButton = UIBarButtonItem(image: buttonIcon, style: .plain, target: self, action: #selector(addUserToFavourites))
        self.navigationItem.setRightBarButton(addToFavouriteBarButton, animated: true)
    }
    
    
    @objc private func addUserToFavourites() {
        
        showLoadingView()
        
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            
            self.removeLoadingView()
            
            switch result {
            case .success(let user):
                self.toggleUserFavourite(user)
            case .failure(let error):
                self.presentGFAlert(title: "Error", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    
    private func toggleUserFavourite(_ user: User) {
        let follower = Follower(login: user.login, avatarUrl: user.avatarUrl?.absoluteString ?? "")
        PersistenceManager.toggleFavourite(user: follower) { [weak self] error in
            guard let self =  self else { return }
            
            if let error = error {
                self.presentGFAlert(title: "Error", message: error.rawValue, buttonTitle: "OK")
                return
            }
            
            self.getIsFavouriteState()
        }
//                PersistenceManager.updateWith(favourite: follower, action: .add) { [weak self] error in
//                    guard let self = self else { return }
//
//                    if let error = error {
//                        self.presentGFAlert(title: "Error", message: error.rawValue, buttonTitle: "OK")
//                        return
//                    }
//                    self.isFavourite = true
//                    self.configureFavouritesButton()
//                    self.presentGFAlert(title: "Success", message: "\(user.login) has been added to favourites", buttonTitle: "OK")
//                }
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
        isLoadingFollowers = true
        NetworkManager.shared.getFollowers(for: username, page: currentPage) { [weak self] result in
            self?.removeLoadingView()
            switch result {
                case .success(let followers):
                    self?.updateUI(with: followers)
                case .failure(let error):
                    self?.presentGFAlert(title: "Error", message: error.rawValue, buttonTitle: "OK")
            }
            self?.isLoadingFollowers = false
        }
    }
    
    
    private func updateUI(with followers: [Follower]) {
        if followers.count < 100 {
            self.hasMoreFollowers = false
        }
        else {
            self.hasMoreFollowers = true
        }
        self.followers.append(contentsOf: followers)
        if self.followers.isEmpty {
            showEmptyStateView(with: "This user has no followers.", in: view)
            return
        }
        updateData(followers: self.followers)
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
        if !hasMoreFollowers || isLoadingFollowers || isSearching { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.bounds.height
        
//        print("--- didEndDrag")
//        print(offsetY)
//        print(contentHeight)
//        print(height)
        if offsetY >= contentHeight - height {
            currentPage += 1
            getFollowers()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let array = isSearching ? filteredFollowers : followers
        let follower = array[indexPath.item]
        let userInfoVC = UserInfoVC()
        userInfoVC.username = follower.login
        userInfoVC.followerListVCDelegate = self
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


//MARK: - Follower List VC Delegate
extension FollowersListVC: FollowerListVCDelegate {
    func didRequestFollowers(forUsername username: String) {
        print("--- didRequestFollowers")
        self.username = username
        self.title = username
        followers.removeAll()
        filteredFollowers.removeAll()
        currentPage = 1
        isSearching = false
        isFavourite = false
        hasMoreFollowers = false
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getIsFavouriteState()
        getFollowers()
    }
    
}
