//
//  UserSettingSection.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-02-14.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//
protocol SectionType: CustomStringConvertible {
    var containsSwitch: Bool { get }
}

enum UserSettingSection: Int, CaseIterable, CustomStringConvertible {
    case Account
    case Settings
    
    var description: String {
        switch self {
        case .Account: return "Account"
        case .Settings: return "Settings"
        }
    }
}

enum AccountOptions: Int, CaseIterable, SectionType {
    case changePassword
    case logout
    
    var containsSwitch: Bool { return false }
    
    var description: String {
        switch self {
        case .changePassword: return "Change Password"
        case .logout: return "Log out"
        }
    }
}

enum SettingsOptions: Int, CaseIterable, SectionType {
    case notification
    
    var containsSwitch: Bool {
        switch self {
        case .notification: return true
        }
    }
    
    var description: String {
        switch self {
        case .notification: return "Notification"
        }
    }
}
