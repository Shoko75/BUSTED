//
//  ApnsUploads.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-22.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import Foundation
import UserNotifications

extension AppDelegate {
    
    func registerCustomActions() {
        let join = UNNotificationAction(identifier: ActionButtonsId.join.rawValue, title: "Join")
        let decline = UNNotificationAction(identifier: ActionButtonsId.decline.rawValue, title: "Decline")
        let categoryButtons = UNNotificationCategory(identifier: categoryButtonsId, actions: [join, decline], intentIdentifiers: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([categoryButtons])
        
    }
    
    
}
