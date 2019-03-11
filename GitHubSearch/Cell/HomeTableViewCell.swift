//
//  HomeTableViewCell.swift
//  GitHubSearch
//
//  Created by Shreya Nanda on 09/03/19.
//  Copyright © 2019 Shreya. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageview: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var watchersCount: UILabel!
    @IBOutlet weak var commitCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
