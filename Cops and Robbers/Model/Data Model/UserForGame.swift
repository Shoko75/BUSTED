//
//  User.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-11.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import Foundation
import CoreLocation

class UserForGame {
    let name: String
    let icon: String?
    let uuid: UUID
    let majorValue: CLBeaconMinorValue
    let minorValue: CLBeaconMinorValue
    
    var beacon: CLBeacon?
    
    init(name: String, icon: String, uuid: UUID, majorValue: Int, minorValue: Int) {
        self.name = name
        self.icon = icon
        self.uuid = uuid
        self.majorValue = CLBeaconMajorValue(majorValue)
        self.minorValue = CLBeaconMinorValue(minorValue)
    }
    
    func asBeaconRegion() -> CLBeaconRegion {
        return CLBeaconRegion(proximityUUID: uuid, major: majorValue, identifier: name)
    }
    
}
