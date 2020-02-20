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
    
    var description: String {
        switch self {
        case .Account: return "Account"
        }
    }
}

enum AccountOptions: Int, CaseIterable, SectionType {
    case changeProfilePicture
    case logout
    
    var containsSwitch: Bool { return false }
    
    var description: String {
        switch self {
        case .changeProfilePicture: return "Change Profile Picture"
        case .logout: return "Log out"
        }
    }
}
