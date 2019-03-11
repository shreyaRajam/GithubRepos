//
//  DetailsCollectionViewCell.swift
//  GitHubSearch
//
//  Created by Shreya Nanda on 09/03/19.
//  Copyright © 2019 Shreya. All rights reserved.
//

import UIKit

class DetailsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var contImage: UIImageView!
    @IBOutlet weak var contName: UILabel!
}

class ContributorImageCell: UICollectionViewCell {
    @IBOutlet weak var contImage: UIImageView!
}

class ContributorLabelsCell: UICollectionViewCell {
    @IBOutlet weak var defLabel: UILabel!
}

class ContributorDescCell: UICollectionViewCell {
    @IBOutlet weak var descLabel: UILabel!
}
