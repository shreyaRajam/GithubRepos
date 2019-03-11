//
//  ContributorsViewController.swift
//  GitHubSearch
//
//  Created by Shreya Nanda on 09/03/19.
//  Copyright © 2019 Shreya. All rights reserved.
//

import UIKit

class ContributorsViewController: UIViewController {

    @IBOutlet weak var contributorsTable: UITableView!
    @IBOutlet weak var contributorImage: UIImageView!
    var selectedContributor: User?
    var selectedRepo: Repo?
    var repoList: [Contributors] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let contributor = selectedContributor else { return }
        getContributorsList(url: contributor.reposUrl)
        contributorImage.image = contributor.avatarImage
        self.navigationItem.title = contributor.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getContributorsList(url: String) {
        Utility.sharedInstance.toggleLoader(true)
        NetWorkLayer.sharedInstance.getContributorsRepoList(contributrsUrl: url) { (contributArr, err) in
            Utility.sharedInstance.toggleLoader(false)
            guard let arr = contributArr else {
                Utility.showAlertFor(err)
                return
            }
            self.repoList.removeAll()
            if arr.isEmpty {
                Utility.showAlertWith(message: "No results found for the query.")
            }
            self.repoList = arr
            DispatchQueue.main.async {
                self.contributorsTable.reloadData()
            }
        }
    }
}

extension ContributorsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let contributeCell = tableView.dequeueReusableCell(withIdentifier: "contributeCell") as? ContributorTableViewCell else {
            fatalError("Cell can't be nil.")
        }
        let repoUrl = repoList[indexPath.row]
        contributeCell.repoName.text = repoUrl.contRepourl
        return contributeCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let repoUrl = repoList[indexPath.row].contRepourl
        Utility.sharedInstance.toggleLoader(true)
        NetWorkLayer.sharedInstance.getRepoDetails(forRepo: repoUrl) { (repo, err) in
            DispatchQueue.main.async {
                Utility.sharedInstance.toggleLoader(false)
                if let repo = repo {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    guard let destVC = storyboard.instantiateViewController(withIdentifier: "RepoDetailsViewController") as? RepoDetailsViewController else { return}
                    destVC.selectedRepo = repo
                    self.navigationController?.pushViewController(destVC, animated: true)
                } else {
                    Utility.showAlertFor(err)
                }
            }
        }
    }
}
