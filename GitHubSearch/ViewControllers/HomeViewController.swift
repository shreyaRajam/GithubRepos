//
//  ViewController.swift
//  GitHubSearch
//
//  Created by Shreya Nanda on 09/03/19.
//  Copyright © 2019 Shreya. All rights reserved.
//

import UIKit
import MBProgressHUD

class HomeViewController: UIViewController {

    var repoArr: [Repo] = []
    @IBOutlet weak var searchTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Repositories"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: TableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repoArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let homeCell = tableView.dequeueReusableCell(withIdentifier: "homecell") as? HomeTableViewCell else {
            fatalError()
        }
        let repo = repoArr[indexPath.row]
        homeCell.name.text = repo.name
        homeCell.fullName.text = repo.fullName
        homeCell.watchersCount.text = "\(repo.watchersCount)"
        homeCell.commitCount.text = "\(repo.commitCount)"
        if let image = repo.owner.avatarImage {
            homeCell.avatarImageview.image = image
        } else {
            homeCell.avatarImageview.image = UIImage(named: "placeHolder")
            NetWorkLayer().getImageFor(repo.owner.avatarUrl) { (image, error) in
                if let image = image {
                   self.updateOwnerImage(image, forRepo: repo.rId)
                } else {
                    print(error ?? "")
                }
            }
        }
        return homeCell
    }

    // MARK: TableView Delegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "ShowRepoDetails", sender: repoArr[indexPath.row])
    }

    func updateOwnerImage(_ image: UIImage, forRepo repoID: Int ) {
        if let index = repoArr.firstIndex(where: { $0.rId == repoID }) {
            let repo = repoArr[index]
            repo.owner.avatarImage = image
            repoArr[index] = repo
            DispatchQueue.main.async {
                self.searchTable.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
    }
}
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        if !(searchBar.text?.isEmpty ?? false) {
            Utility.sharedInstance.toggleLoader(true)
            NetWorkLayer.sharedInstance.getSearchedResults(searchText: searchBar.text!) { (repoArr, err) in
                Utility.sharedInstance.toggleLoader(false)
                guard let arr = repoArr else {
                    Utility.showAlertFor(err)
                    return
                }
                self.repoArr.removeAll()
                if arr.isEmpty {
                    Utility.showAlertWith(message: "No results found for the query.")
                }
                self.repoArr = arr
                DispatchQueue.main.async {
                    self.searchTable.reloadData()
                }
            }
        }
    }
}

// MARK: Navigation methods
extension HomeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRepoDetails", let destinationVC = segue.destination as? RepoDetailsViewController, let repo = sender as? Repo {
            destinationVC.selectedRepo = repo
        }
    }
}
