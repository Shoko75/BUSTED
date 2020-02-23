//
//  UserSettingSection.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-02-14.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

// MARK: Procol -SectionType
protocol SectionType: CustomStringConvertible {
    var containsSwitch: Bool { get }
}

// MARK: UserSettingSection
enum UserSettingSection: Int, CaseIterable, CustomStringConvertible {
    case Account
    
    var description: String {
        switch self {
        case .Account: return "Account"
        }
    }
}

// MARK: AccountOptions
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
