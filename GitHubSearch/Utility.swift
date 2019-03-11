//
//  Utility.swift
//  GitHubSearch
//
//  Created by Shreya Nanda on 3/9/19.
//  Copyright © 2019 Shreya. All rights reserved.
//

import UIKit
import MBProgressHUD

class Utility: NSObject {
    static let sharedInstance = Utility()
    static func showAlertWith(message: String, title: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            Utility.topMostController()?.present(alertController, animated: true, completion: nil)
        }
    }

    static func showAlertFor(_ error: Error?) {
        Utility.showAlertWith(message: error?.localizedDescription ?? "Unknown error. Please try again.", title: "Error")
    }

    static func topMostController() -> UIViewController? {
        guard let window = UIApplication.shared.keyWindow, let rootViewController = window.rootViewController else {
            return nil
        }
        var topController = rootViewController
        while let newTopController = topController.presentedViewController {
            topController = newTopController
        }
        return topController
    }

    func toggleLoader(_ turnOn: Bool) {
        DispatchQueue.main.async {
            if let topMostVC = Utility.topMostController() {
                if turnOn {
                    MBProgressHUD.showAdded(to: topMostVC.view, animated: true)
                } else {
                    MBProgressHUD.hide(for: topMostVC.view, animated: true)
                }
            }
        }
    }
}
