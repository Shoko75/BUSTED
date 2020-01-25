//
//  notification.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-24.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let joinButton = Notification.Name("joinTapped")
    static let declineButton = Notification.Name("declineTapped")
    
    func post(center: NotificationCenter = NotificationCenter.default,
              object: Any? = nil, userInfo: [AnyHashable : Any]? = nil) {
        
    }
}
