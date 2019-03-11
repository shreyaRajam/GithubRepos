//
//  Repo.swift
//  GitHubSearch
//
//  Created by Shreya Nanda on 09/03/19.
//  Copyright © 2019 Shreya. All rights reserved.
//

import Foundation
import UIKit

struct RepoWarapper: Decodable {
    var items: [Repo]
}

struct Repo: Decodable {

    var rId: Int
    var name: String
    var fullName: String
    var watchersCount: Int
    var commitCount: Int
    var projectLink: String
    var repoDescription: String
    var contributorsUrl: String
    var owner: User

    enum CodingKeys: String, CodingKey {
        case rId = "id"
        case fullName = "full_name"
        case watchersCount = "watchers_count"
        case commitCount = "open_issues" //Commit count is not present
        case name = "name"
        case projectLink = "html_url"
        case repoDescription = "description"
        case contributorsUrl = "contributors_url"
        case owner = "owner"
    }
}
