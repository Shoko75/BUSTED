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
    case About
    
    var description: String {
        switch self {
        case .Account: return "Account"
        case .About: return "About"
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

// MARK: About
enum AboutOptions: Int, CaseIterable, SectionType {
    case termsAndConditions
    case privacyPolicy
    
    var containsSwitch: Bool { return false }
    
    var description: String {
        switch self {
        case .termsAndConditions: return "Terms and conditions"
        case .privacyPolicy: return "Privacy policy"
        }
    }
}
