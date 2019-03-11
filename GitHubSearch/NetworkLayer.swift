//
//  NetworkLayer.swift
//  GitHubSearch
//
//  Created by Shreya Nanda on 09/03/19.
//  Copyright © 2019 Shreya. All rights reserved.
//

import Foundation
import UIKit

class NetWorkLayer: NSObject {
    static let sharedInstance = NetWorkLayer()

    func getSearchedResults(searchText: String, completionHandler: @escaping (_ repo: [Repo]?, _ err: Error?) -> Void) {
        let urlString = UrlConstants.searchUrl + "\(searchText)" + "&per_page=10"
        toggleNetworkIndictor(true)
        ServiceLayer().getDataFor(urlString) {[unowned self] (data, error) in
            self.toggleNetworkIndictor(false)
            if let data = data {
                do {
                    let repoWrapper = try JSONDecoder().decode(RepoWarapper.self, from: data)
                    let repoArr = repoWrapper.items
                    completionHandler(repoArr, nil)
                } catch {
                    completionHandler(nil, error)
                }
            } else {
                completionHandler(nil, error)
            }
        }
    }
    func getRepoDetails(forRepo url: String, completionHandler: @escaping(_ repo: Repo?, _ err: Error?) -> Void) {
        toggleNetworkIndictor(true)
        ServiceLayer().getDataFor(url) {[unowned self] (data, error) in
            self.toggleNetworkIndictor(false)
            if let data = data {
                do {
                    let selectedRepo = try JSONDecoder().decode(Repo.self, from: data)
                    completionHandler(selectedRepo, nil)
                } catch {
                    completionHandler(nil, error)
                }
            } else {
                completionHandler(nil, error)
            }
        }
    }
    func getContributorsList(contributrsUrl: String, completionHandler: @escaping (_ repo: [User]?, _ err: Error?) -> Void) {
        ServiceLayer().getDataFor(contributrsUrl) {[unowned self] (data, error) in
            self.toggleNetworkIndictor(false)
            if let data = data {
                do {
                    let contributorsList = try JSONDecoder().decode([User].self, from: data)
                    completionHandler(contributorsList, nil)
                } catch {
                    completionHandler(nil, error)
                }
            } else {
                completionHandler(nil, error)
            }
        }
    }

    func getContributorsRepoList(contributrsUrl: String, completionHandler: @escaping (_ repo: [Contributors]?, _ err: Error?) -> Void) {
        ServiceLayer().getDataFor(contributrsUrl) {[unowned self] (data, error) in
            self.toggleNetworkIndictor(false)
            if let data = data {
                do {
                    let repoList = try JSONDecoder().decode([Contributors].self, from: data)
                    completionHandler(repoList, nil)
                } catch {
                    completionHandler(nil, error)
                }
            } else {
                completionHandler(nil, error)
            }
        }
    }

    func getImageFor(_ urlString: String, completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> Void ) {
        ServiceLayer().getDataFor(urlString) {(data, error) in
            if let data = data, let image = UIImage(data: data) {
                completionHandler(image, nil)
            } else {
                completionHandler(nil, error)
            }
        }
    }

    private func toggleNetworkIndictor(_ turnOn: Bool) {
        DispatchQueue.main.async {
            if UIApplication.shared.isNetworkActivityIndicatorVisible != turnOn {
                UIApplication.shared.isNetworkActivityIndicatorVisible = turnOn
            }
        }
    }
}
