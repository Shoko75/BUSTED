//
//  User.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-11.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import Foundation
import CoreLocation

class User {
    let name: String
    let icon: String
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
    
    func nameForProximity(_ proximity: CLProximity) -> String {
      switch proximity {
      case .unknown:
        return "Unknown"
      case .immediate:
        return "Immediate"
      case .near:
        return "Near"
      case .far:
        return "Far"
      }
    }
    
    func locationString() -> String {
      guard let beacon = beacon else { return "Location: Unknown" }
      let proximity = nameForProximity(beacon.proximity)
      let accuracy = String(format: "%.2f", beacon.accuracy)
        
      var location = "Location: \(proximity)"
      if beacon.proximity != .unknown {
        location += " (approx. \(accuracy)m)"
      }
        
      return location
    }
}

func ==(user: User, beacon: CLBeacon) -> Bool {
    return ((beacon.proximityUUID.uuidString == user.uuid.uuidString) && (Int(beacon.major) == Int(user.majorValue)) && (Int(beacon.minor) == Int(user.minorValue)))
}
