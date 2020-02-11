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
import UserNotifications
import Firebase

class MapViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusNumLabel: UILabel!

    private let center = UNUserNotificationCenter.current()
    let locationManager = CLLocationManager()
    
    var mapViewModel: MapViewModel!
    var localBeacon: CLBeaconRegion!
    var localBeaconIdentityConstraint: CLBeaconIdentityConstraint!
    var beaconPeripheralData: [String:Any]?
    var peripheralManager: CBPeripheralManager!
    var appIdentifier = "com.shokohashimoto.CopsAndRobber"
    var beaconsToRange = [CLBeaconRegion]()
    var currentLocation: CLLocation!
    var gameData: Game?
    var flgCops: Bool?
    var gameID: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapViewModel = MapViewModel()
        mapViewModel.mapDelegate = self
        mapViewModel.gameID = self.gameID!
        mapViewModel.flgCops = self.flgCops!
        mapViewModel.observeGame()
        mapViewModel.setEnemyData(gameData: gameData!)
        let myGameUuid = mapViewModel.searchMyGameUuid(gameData: gameData!)
        
        // Monitaring setting
        startMonitoringUser()
        initLocalBeacon(gameUuid: myGameUuid)
        
        
        // Map setting
        mapView.showsUserLocation = true
        
        // Darawing the field
        let location = CLLocation(latitude: Double((gameData?.field.latitude)!)!, longitude: Double((gameData?.field.longitude)!)!)
        let regionRadius: CLLocationDistance = 1500
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        mapView.setRegion(region, animated: true)
        addRadiusCircle(location: location)
        
        // Set exit notification of the field
        let geofenceRegionCenter = CLLocationCoordinate2DMake(Double((gameData?.field.latitude)!)!, Double((gameData?.field.longitude)!)!)
        let radiusOfNotify: CLLocationDistance = 100
        let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter, radius: radiusOfNotify, identifier: "Field")
        geofenceRegion.notifyOnExit = true
        locationManager.startMonitoring(for: geofenceRegion)
        
        
    }
    
    // Beacon setting
    override func viewDidDisappear(_ animated: Bool) {
        // TODO: Need to change later
        stopMonitoringUser()
        stopLocalBeacon()
    }
    
    func startMonitoringUser() {
        for enemy in mapViewModel.enemys {
            let beaconRegion = enemy.asBeaconRegion()
            locationManager.startMonitoring(for: beaconRegion)
            locationManager.startRangingBeacons(in: beaconRegion)
        }
    }
    
    func stopMonitoringUser() {
        for enemy in mapViewModel.enemys {
            let beaconRegion = enemy.asBeaconRegion()
            locationManager.stopMonitoring(for: beaconRegion)
            locationManager.stopRangingBeacons(in: beaconRegion)
        }
    }
    
    func initLocalBeacon(gameUuid: String){
        if localBeacon != nil {
            stopLocalBeacon()
        }
        
        var localBeaconManajor: CLBeaconMajorValue?
        let localBeaconMinor: CLBeaconMinorValue = 1
        
        if flgCops! {
            localBeaconManajor = UInt16(gameData!.cops.major)
        } else {
            localBeaconManajor = UInt16(gameData!.robbers.major)
        }
        
        localBeaconIdentityConstraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: gameUuid)!, major: localBeaconManajor!, minor: localBeaconMinor)
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
    
    
    // Map setting
    func addRadiusCircle(location: CLLocation) {
        self.mapView.delegate = self
        var circle = MKCircle(center: location.coordinate, radius: 100 as CLLocationDistance)
        self.mapView.addOverlay(circle)
    }
}

extension MapViewController: MapDelegate {
    func didObserve() {
    print("")
    }
    
}

// MARK: CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        var indexPaths = [IndexPath]()
        var printInfo = ""
        var alert = ""
        for beacon in beacons {
            for row in 0..<mapViewModel.enemys.count {
                
                    mapViewModel.enemys[row].beacon = beacon
                    indexPaths += [IndexPath(row: row, section: 0)]
                    print(mapViewModel.enemys[row].name)
                    
                    
                    let bea = beacon as CLBeacon
                    
                    let title = "------------ number \(beacons.count) -----------------\n"
                    let name = "Name: \(mapViewModel.enemys[row].name) \n"
                    let major = "major: \(bea.major.intValue) \n"
                    let minor = "minor: \(bea.minor.intValue) \n"

                    let location = "location: \(mapViewModel.enemys[row].locationString()) \n"
                    alert = mapViewModel.enemys[row].alertForProximity(beacon.proximity, flgCops: flgCops!)
                mapViewModel.controlProcessingByProximity(gameUuid: bea.uuid.uuidString)
                    printInfo += title + name + major + minor + location
            }
        }
        
        print(printInfo)
        textView.text = printInfo
        
        if alert == "Unknown" || alert == "" {
            alertLabel.isHidden = true
        } else {
            alertLabel.isHidden = true
            alertLabel.text = alert
        }
        

    }
    
    
    // Error handling
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
      print("Failed monitoring region: \(error.localizedDescription)")
    }
      
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      print("Location manager failed: \(error.localizedDescription)")
    }
    
    // Map Setting
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last as CLLocation?
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


// MARK: MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let circle = MKCircleRenderer(overlay: overlay)
        circle.strokeColor = UIColor.red
        circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
        circle.lineWidth = 2
        return circle
    }
}


// MARK: UNUserNotificationCenterDelegate
extension MapViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        
    }
}
