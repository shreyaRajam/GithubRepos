//
//  WebViewViewController.swift
//  GitHubSearch
//
//  Created by Shreya Nanda on 3/11/19.
//  Copyright © 2019 Shreya. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    var urlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let urlString = urlString, let url = URL(string: urlString) else {
            fatalError("Specify url to load.")
        }
        webView.navigationDelegate = self
        Utility.sharedInstance.toggleLoader(true)
        webView.load(URLRequest(url: url))
    }

    // MARK: WKNavigationDelegate methods
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title = webView.title
        Utility.sharedInstance.toggleLoader(false)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Utility.sharedInstance.toggleLoader(false)
        Utility.showAlertFor(error)
    }
}
