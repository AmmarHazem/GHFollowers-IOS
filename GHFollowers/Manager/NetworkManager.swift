//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Ammar on 14/02/2021.
//

import UIKit


struct NetworkManager {
    static let shared = NetworkManager()
    private let cache = NSCache<NSString, UIImage>()
    private let baseURL = "https://api.github.com"
    private let followersPerPage = 100
    
    
    private init() {
        //        cache.countLimit = 200
        cache.totalCostLimit = 200
    }
    
    
    func downloadImage(from url: URL, completed: @escaping (UIImage?) -> Void) {
        let task = URLSession(configuration: .default).dataTask(with: url) { data, response, error in
            if error != nil {
                DispatchQueue.main.async { completed(nil) }
                return
            }
            guard let response = response as? HTTPURLResponse,
                  response.statusCode >= 200 && response.statusCode < 300,
                  let data = data,
                  let image = UIImage(data: data)
            else {
                DispatchQueue.main.async { completed(nil) }
                return
            }
            self.addImageToCache(image, forKey: NSString(string: url.absoluteString), cost: data.count)
            DispatchQueue.main.async { completed(image) }
        }
        task.resume()
    }
    
    
    func getUserInfo(for username: String, complitionHandler: @escaping (Result<User, GFError>) -> Void) {
        let url = URL(string: "\(baseURL)/users/\(username)")!
        let task = URLSession(configuration: .default).dataTask(with: url) { data, response, error in
            
            if error != nil {
                print("--- getUserInfo error 1")
                DispatchQueue.main.async {
                    complitionHandler(.failure(.networkError))
                }
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode >= 200 && response.statusCode < 300,
                  let data = data
            else {
                print("--- getUserInfo error 2")
                DispatchQueue.main.async {
                    complitionHandler(.failure(GFError.defaultMessage))
                }
                return
            }
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            jsonDecoder.dateDecodingStrategy = .iso8601
            let user = try? jsonDecoder.decode(User.self, from: data)
            if let user = user {
                DispatchQueue.main.async {
                    complitionHandler(.success(user))
                }
            }
            else {
                print("--- getUserInfo error 3")
                DispatchQueue.main.async {
                    complitionHandler(.failure(.defaultMessage))
                }
            }
        }
        task.resume()
    }
    
    
    func addImageToCache(_ image: UIImage, forKey key: NSString, cost: Int) {
        cache.setObject(image, forKey: key, cost: cost)
    }
    
    
    func getImageFromCache(with url: NSString) -> UIImage? { cache.object(forKey: url) }
    
    
    func getFollowers(for username: String, page: Int, complitionHandler: @escaping (Result<[Follower], GFError>) -> Void) {
        let urlStr = "\(baseURL)/users/\(username)/followers?per_page=\(followersPerPage)&page=\(page)"
        let url = URL(string: urlStr)!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if error != nil {
                print("--- response error 1")
                DispatchQueue.main.async { complitionHandler(.failure(.networkError)) }
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode >= 200 && response.statusCode < 300,
                  let data = data else {
                print("--- response error 2")
                DispatchQueue.main.async { complitionHandler(.failure(.defaultMessage)) }
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let followers = try? decoder.decode([Follower].self, from: data) {
                DispatchQueue.main.async { complitionHandler(.success(followers)) }
            }
            else {
                DispatchQueue.main.async { complitionHandler(.failure(.defaultMessage)) }
            }
            
        }
        task.resume()
    }
}
