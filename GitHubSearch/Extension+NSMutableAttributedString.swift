//
//  Extension+NSMutableAttributedString.swift
//  GitHubSearch
//
//  Created by Shreya Nanda on 3/11/19.
//  Copyright © 2019 Shreya. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    public func setLink(forRange text: String, linkText: String) {
        let range = self.mutableString.range(of: text)
        if range.location != NSNotFound {
            self.addAttribute(.link, value: linkText, range: range)
        }
    }
}
