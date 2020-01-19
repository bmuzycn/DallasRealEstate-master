//
//  LocalizedString.swift
//  DallasRE2
//
//  Created by Tim on 1/18/20.
//  Copyright © 2020 Yu Zhang. All rights reserved.
//

import Foundation
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

}
