//
//  MenuOption.swift
//
//  Created by Yu Zhang on 01/12/2020.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import UIKit

enum MenuOption: Int, CustomStringConvertible {
    
    case Profile
    case Inbox
    case Notifications
    case Settings
    
    var description: String {
        switch self {
        case .Profile: return "Profile".localized
        case .Inbox: return "Email".localized
        case .Notifications: return "Notifications".localized
        case .Settings: return "Settings".localized
        }
    }
    
    var image: UIImage {
        switch self {
        case .Profile: return UIImage(named: "ic_person_outline_white_2x") ?? UIImage()
        case .Inbox: return UIImage(named: "ic_mail_outline_white_2x") ?? UIImage()
        case .Notifications: return UIImage(named: "notification") ?? UIImage()
        case .Settings: return UIImage(named: "baseline_settings_white_24dp") ?? UIImage()
        }
    }
}
