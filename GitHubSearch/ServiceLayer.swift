//
//  ServiceLayer.swift
//  GitHubSearch
//
//  Created by Shreya Nanda on 3/9/19.
//  Copyright © 2019 Shreya. All rights reserved.
//

import UIKit

class ServiceLayer: NSObject {

    func getDataFor(_ urlStr: String, completionHandler: @escaping(_ repo: Data?, _ err: Error?) -> Void) {
        guard let url = URL(string: urlStr) else {
            completionHandler(nil, nil)
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: url) {(data, _, error) in
            completionHandler(data, error )
        }
        task.resume()
    }
}
