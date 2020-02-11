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
        @unknown default:
        fatalError()
        }
    }
    
    func alertForProximity(_ proximity: CLProximity, flgCops: Bool) -> String {
        
        var alert = ""
        switch proximity {
        case .unknown:
            return "Unknown"
        case .immediate:

            if flgCops {
                alert = "YOU COUGHT A ROBBER!!"
            } else {
                alert = "YOU'VE BEEN SENT TO JAIL! "
            }
            return alert
            
        case .near:
            if flgCops {
                alert = "ALERT! A ROBBER IS NEARBY!"
            } else {
                alert = "ALERT! A COP IS NEARBY!"
            }
            
            return alert
        case .far:
            if flgCops {
                alert = "ALERT! A ROBBER IS NEARBY!"
            } else {
                alert = "ALERT! A COP IS NEARBY!"
            }
        
        return alert
        @unknown default:
        fatalError()
        }
    }
    
    func locationString() -> String {
      guard let beacon = beacon else { return "Location: Unknown" }
      let proximity = nameForProximity(beacon.proximity)
      let accuracy = String(format: "%.2f", beacon.accuracy)
        
      var location = " \(proximity)"
      if beacon.proximity != .unknown {
        location += " (approx. \(accuracy)m)"
      }
        
      return location
    }
    
}
