//
//  User.swift
//  GitHubSearch
//
//  Created by Shreya Nanda on 3/9/19.
//  Copyright © 2019 Shreya. All rights reserved.
//

import UIKit

class User: Decodable {
    var name: String
    var rId: Int
    var reposUrl: String
    var avatarUrl: String = ""
    var avatarImage: UIImage?

    enum CodingKeys: String, CodingKey {
        case rId = "id"
        case name = "login"
        case reposUrl = "repos_url"
        case avatarUrl = "avatar_url"
    }
}
