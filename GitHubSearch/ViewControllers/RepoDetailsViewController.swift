//
//  RepoDetailsViewController.swift
//  GitHubSearch
//
//  Created by Shreya Nanda on 09/03/19.
//  Copyright © 2019 Shreya. All rights reserved.
//

import UIKit
import WebKit

class RepoDetailsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var selectedRepo: Repo!
    var repoDetailsArr: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Repoistory Details"
        if selectedRepo == nil {
            fatalError()
        }
        self.getContributors(url: selectedRepo.contributorsUrl)
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContributorRepList", let destinationVC = segue.destination as? ContributorsViewController, let repo = sender as? User {
            destinationVC.selectedContributor = repo

        } else if segue.identifier == "ShowWebView", let destinationVC = segue.destination as? WebViewViewController {
            destinationVC.urlString = sender as? String
        }
    }
    func openWebViewOnClicking(projLink: String) {
        self.performSegue(withIdentifier: "ShowWebView", sender: projLink)
    }
    func updateOwnerImage(_ image: UIImage, forRepo repoID: Int ) {
        if let index = repoDetailsArr.firstIndex(
            where: { $0.rId == repoID }) {
            let repo = repoDetailsArr[index]
            repo.avatarImage = image
            repoDetailsArr[index] = repo
            DispatchQueue.main.async {
                self.collectionView.reloadItems(at: [IndexPath(row: index, section: 6)])
            }
        }
    }
    func getContributors(url: String) {
        Utility.sharedInstance.toggleLoader(true)
        NetWorkLayer.sharedInstance.getContributorsList(contributrsUrl: url ) { (repoDetArr, err) in
            Utility.sharedInstance.toggleLoader(false)
            guard let arr = repoDetArr else {
                Utility.showAlertFor(err)
                return
            }
            self.repoDetailsArr.removeAll()
            if arr.isEmpty {
                Utility.showAlertWith(message: "No results found for the query.")
            }
            self.repoDetailsArr = arr
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK: CollectionviewDataSource methods
extension RepoDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 6:
            return self.repoDetailsArr.count
        default:
            return 1
        }
    }

    // swiftlint:disable cyclomatic_complexity function_body_length
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ContributorImageCell else {
                fatalError()
            }
            imageCell.contImage.image = selectedRepo.owner.avatarImage
            return imageCell
        case 1:
            guard let labelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "defaltLabelCell", for: indexPath) as? ContributorLabelsCell else {
                fatalError()
            }
            labelCell.defLabel.text = selectedRepo.fullName
            return labelCell
        case 2:
            guard let labelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "defaltLabelCell", for: indexPath) as? ContributorLabelsCell else {
                fatalError()
            }
            let mainString = "ProjectLink :" + selectedRepo.projectLink
            let stringTocolor = selectedRepo.projectLink
            let range = (mainString as NSString).range(of: stringTocolor)
            let attribute = NSMutableAttributedString.init(string: mainString)
            attribute.addAttribute(.link, value: UIColor.blue, range: range)
            labelCell.defLabel.attributedText = attribute
            return labelCell
        case 3:
            guard let labelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "defaltLabelCell", for: indexPath) as? ContributorLabelsCell else {
                fatalError()
            }
            labelCell.defLabel.text = "Description :"
            return labelCell
        case 4:
            guard let descCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescCell", for: indexPath) as? ContributorDescCell else {
                fatalError()
            }
            descCell.descLabel.text = selectedRepo.repoDescription
            return descCell
        case 5:
            guard let labelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "defaltLabelCell", for: indexPath) as? ContributorLabelsCell else {
                fatalError()
            }
            labelCell.defLabel.text = "Contributors :"
            return labelCell
        default:
            guard let detailsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailsCell", for: indexPath) as? DetailsCollectionViewCell else {
                fatalError()
            }
            let repo = self.repoDetailsArr[indexPath.row]
            detailsCell.contName.text = repo.name
            if let image = repo.avatarImage {
                detailsCell.contImage.image = image
            } else {
                detailsCell.contImage.image = UIImage(named: "placeHolder")
                NetWorkLayer().getImageFor(repo.avatarUrl) { (image, error) in
                    if let image = image {
                        self.updateOwnerImage(image, forRepo: repo.rId)
                    } else {
                        print(error ?? "")
                    }
                }
            }
            return detailsCell
        }
    }

    // MARK: CollectionviewDelegate methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.section == 6 {
            self.performSegue(withIdentifier: "ContributorRepList", sender: repoDetailsArr[indexPath.row])
        } else if indexPath.section == 2 {
            openWebViewOnClicking(projLink: selectedRepo.projectLink)
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
// TODO: Modify this to use dynamic sizes.
extension RepoDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.size.width
        switch indexPath.section {
        case 0:
            return CGSize(width: 100.0, height: 100.0 )
        case 1, 2, 3, 5:
            return CGSize(width: width, height: 21.0 )
        case 4:
            return CGSize(width: width, height: 21.0 )
        default:
            return CGSize(width: 50.0, height: 50.0 )
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            let totalCellWidth = 80 * collectionView.numberOfItems(inSection: 0)
            let totalSpacingWidth = 10 * (collectionView.numberOfItems(inSection: 0) - 1)
            let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
            let rightInset = leftInset
            return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        } else {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
}
