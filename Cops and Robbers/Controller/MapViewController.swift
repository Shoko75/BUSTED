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
    var localBeacon: CLBeaconRegion!
    var localBeaconIdentityConstraint: CLBeaconIdentityConstraint!
    var beaconPeripheralData: [String:Any]?
    var peripheralManager: CBPeripheralManager!
    var uuid: UUID!
    var appIdentifier = "com.shokohashimoto.CopsAndRobbers"
    var beaconsToRange = [CLBeaconRegion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let user1 = User(name: "Cops", icon: "iconTest1", uuid: UUID(uuidString: "D6826348-41C8-43F6-88D5-DE7EF99426AA")!, majorValue: 20, minorValue: 1)
        
        mapViewModel = MapViewModel(user: user1)
       // mapViewModel.users.append(user2)
        //mapViewModel.users.append(user3)
        // TODO: Should change later
        startMonitoringUser()
        initLocalBeacon()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // TODO: Need to change later
        stopMonitoringUser()
        stopLocalBeacon()
    }
    
    func startMonitoringUser() {
        for user in mapViewModel.users {
            var beaconRegion = user.asBeaconRegion()
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
    
    func initLocalBeacon(){
        if localBeacon != nil {
            stopLocalBeacon()
        }
        
        let localBeaconManajor: CLBeaconMajorValue = 30 // teamID
        let localBeaconMinor: CLBeaconMinorValue = 1 // cop or rubber
        
       //uuid = UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D") // ESTIMONI
       uuid = UUID(uuidString: "D6826348-41C8-43F6-88D5-DE7EF99426AA") // RedBear
//        uuid = UUID(uuidString: "05F62A3D-F60F-44BC-B36E-2B80FD6C9679") // My Beacon Device
        localBeaconIdentityConstraint = CLBeaconIdentityConstraint(uuid: uuid, major: localBeaconManajor, minor: localBeaconMinor)
        localBeacon = CLBeaconRegion(beaconIdentityConstraint: localBeaconIdentityConstraint, identifier: appIdentifier)
        beaconPeripheralData = localBeacon.peripheralData(withMeasuredPower: nil) as? [String: Any]
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
    }
    
    func stopLocalBeacon(){
        peripheralManager.stopAdvertising()
        peripheralManager = nil
        beaconPeripheralData = nil
        localBeacon = nil
    }
}

// MARK - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        var indexPaths = [IndexPath]()
        var printInfo = ""
        
        for beacon in beacons {
            for row in 0..<mapViewModel.users.count {
                
                //if mapViewModel.users[row] == beacon {
                    mapViewModel.users[row].beacon = beacon
                    indexPaths += [IndexPath(row: row, section: 0)]
                    print(mapViewModel.users[row].name)
                    
                    
                    let bea = beacon as CLBeacon
                    
                    let title = "------------ number \(beacons.count) -----------------\n"
                    let name = "Name: \(mapViewModel.users[row].name) \n"
                    let major = "major: \(bea.major.intValue) \n"
                    let minor = "minor: \(bea.minor.intValue) \n"
                    let location = "location: \(mapViewModel.users[row].locationString()) \n"
                    
                    printInfo += title + name + major + minor + location
                    
                    
                //}
            }
        }
        
        print(printInfo)
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

// MARK: CBPeripheralManagerDelegate
extension MapViewController: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            peripheralManager.startAdvertising(beaconPeripheralData)
        } else if peripheral.state == .poweredOff {
            peripheralManager.stopAdvertising()
        }
    }
}
