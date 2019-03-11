//
//  Contributors.swift
//  GitHubSearch
//
//  Created by Shreya Nanda on 3/11/19.
//  Copyright © 2019 Shreya. All rights reserved.
//

import Foundation

struct Contributors: Decodable {
    var contRepourl: String
    enum CodingKeys: String, CodingKey {
        case contRepourl="url"
    }
}
