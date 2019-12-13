//
//  MapViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-11.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreBluetooth

class MapViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!

    let locationManager = CLLocationManager()
    
    var mapViewModel: MapViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let user1 = User(name: "Test1", icon: "iconTest1", uuid: UUID(uuidString: "05F62A3D-F60F-44BC-B36E-2B80FD6C9679")!, majorValue: 10, minorValue: 1)
        mapViewModel = MapViewModel(user: user1)
        
        // TODO: Should change later
        startMonitoringUser()
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // TODO: Need to change later
        stopMonitoringUser()
    }
    
    func startMonitoringUser() {
        for user in mapViewModel.users {
            let beaconRegion = user.asBeaconRegion()
            locationManager.startMonitoring(for: beaconRegion)
            locationManager.startRangingBeacons(in: beaconRegion)
        }
    }
    
    func stopMonitoringUser() {
        for user in mapViewModel.users {
            let beaconRegion = user.asBeaconRegion()
            locationManager.stopMonitoring(for: beaconRegion)
            locationManager.stopRangingBeacons(in: beaconRegion)
        }
    }
    
}

// MARK - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        var indexPaths = [IndexPath]()
        for beacon in beacons {
            for row in 0..<mapViewModel.users.count {
                
                if mapViewModel.users[row] == beacon {
                    mapViewModel.users[row].beacon = beacon
                    indexPaths += [IndexPath(row: row, section: 0)]
                    print(mapViewModel.users[row].name)
                }
            }
        }
        var printInfo = ""
        for index in indexPaths {
            let title = "------------ number \(index[0]) -----------------\n"
            let name = "Name: \(mapViewModel.users[index[0]].name) \n"
            let major = "major: \(mapViewModel.users[index[0]].majorValue) \n"
            let minor = "minor: \(mapViewModel.users[index[0]].minorValue) \n"
            let location = "location: \(mapViewModel.users[index[0]].locationString()) \n"
            
            printInfo += title + name + major + minor + location
            
        }
        
        textView.text = printInfo
    }
    
    
    // Error handling
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
      print("Failed monitoring region: \(error.localizedDescription)")
    }
      
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      print("Location manager failed: \(error.localizedDescription)")
    }
}

extension MapViewController: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        <#code#>
    }
    
    
}
