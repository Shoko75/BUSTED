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

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusNumLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var jailImageView: UIImageView!
    
    let FIELD_RADIUS: CLLocationDistance = 500
    
    private let center = UNUserNotificationCenter.current()
    let locationManager = CLLocationManager()
    
    fileprivate var mapViewModel = MapViewModel()
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
    var winCopsFlg: Bool?
    var myGameUuid: String?

    // MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()

        // Layout Setting
        layoutSetting()
        
        // Delegate
        mapViewModel.mapDelegate = self
        
        // Notification authorization check
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Fetch game data
        mapViewModel.gameID = self.gameID!
        mapViewModel.flgCops = self.flgCops!
        mapViewModel.setEnemyData(gameData: gameData!)
        myGameUuid = mapViewModel.searchMyGameUuid(gameData: gameData!)
        
        // Darawing the field
        let location = CLLocation(latitude: Double((gameData?.field.latitude)!)!, longitude: Double((gameData?.field.longitude)!)!)
        let regionRadius: CLLocationDistance = 1000
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        mapView.setRegion(region, animated: true)
        addRadiusCircle(location: location)
        
        // Set exit notification of the field
        setFieldNotification(location: location)
        
        // Set Flags
        setFlags()
        
        if !flgCops! { // flag monitoring is only for robbers
            startFlagsMonitoring()
        }
        
        // Observe Game data
        mapViewModel.observeGame()
        mapViewModel.observeUserInfo()
        
        // Show Countdown page
        performSegue(withIdentifier: "showCountdown", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBar()
    }
    
    func setNavBar() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        // Title
        let logo = UIImage(named: "Busted_logo_navbar")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        if mapViewModel.checkAdmin(gameData: gameData!) {
            // Right Item
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "exit"), style: .plain, target: self, action: #selector(prepareForeExit))
        }
    }
    
    @objc func prepareForeExit() {
        print("prepareForeExit")
        let alert = UIAlertController(title: "End Game", message: "Are you sure to finish this game?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.prepareForEndGame()
            self.mapViewModel.deleteUserInfoPlayTeam()
            self.backToMenu()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    func setFieldNotification(location: CLLocation) {
        print("setFieldNotification")
        let geofenceRegion = CLCircularRegion(center: location.coordinate, radius: FIELD_RADIUS, identifier: "Field")
        geofenceRegion.notifyOnExit = true
        locationManager.startMonitoring(for: geofenceRegion)
    }
    
    func layoutSetting() {
        
        // Map setting
        mapView.showsUserLocation = true
        
        alertLabel.isHidden = true
        jailImageView.isHidden = true
        
        if flgCops! {
            statusLabel.text = "ROBBERS"
            if let robbersCnt = gameData?.robbers.robPlayers.count {
                statusNumLabel.text = String(robbersCnt)
            }
            backgroundImageView.image = UIImage(named: "playerlist_police_bg")
        } else {
            statusLabel.text = "MONEY BAGS"
            if let flgCnt = gameData?.flags.count {
                statusNumLabel.text = String(flgCnt)
            }
            backgroundImageView.image = UIImage(named: "playerlist_robbers_bg")
        }
    }
    
    func addRadiusCircle(location: CLLocation) {
        print("addRadiusCircle")
        self.mapView.delegate = self
        let circle = MKCircle(center: location.coordinate, radius: FIELD_RADIUS)
        self.mapView.addOverlay(circle)
    }
    
    // MARK: Monitoring Enemys Setting
    func startMonitoringUser() {
        print("startMonitoringUser")
        for enemy in mapViewModel.enemys {
            let beaconRegion = enemy.asBeaconRegion()
            locationManager.startMonitoring(for: beaconRegion)
            locationManager.startRangingBeacons(in: beaconRegion)
        }
    }
    
    func stopMonitoring() {
        print("stopMonitoring")
        for enemy in mapViewModel.enemys {
            let beaconRegion = enemy.asBeaconRegion()
            locationManager.stopMonitoring(for: beaconRegion)
            locationManager.stopRangingBeacons(in: beaconRegion)
        }
        
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
    }
    
    // MARK: Beacon
    func initLocalBeacon(gameUuid: String){
        print("initLocalBeacon")
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
        print("stopLocalBeacon")
        if peripheralManager != nil {
            peripheralManager.stopAdvertising()
            peripheralManager = nil
            beaconPeripheralData = nil
            localBeacon = nil
        }
    }
    
    // MARK: Flags Setting
    func setFlags() {
        print("setFlags")
        for flag in self.gameData!.flags {
            let showflag = MKPointAnnotation()
            showflag.coordinate = CLLocationCoordinate2D(latitude: Double(flag.latitude)!, longitude: Double(flag.longitude)!)
            mapView.addAnnotation(showflag)
        }
    }
    
    func startFlagsMonitoring() {
        print("startFlagsMonitoring")
        var cnt = 0
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            for flag in self.gameData!.flags {
                let flagLocation = CLLocationCoordinate2D(latitude: Double(flag.latitude)!, longitude: Double(flag.longitude)!)
                let region = CLCircularRegion(center: flagLocation, radius: 5, identifier: "\(cnt)")
                region.notifyOnEntry = true
                locationManager.startMonitoring(for: region)
                cnt += 1
            }
        }
    }
    
    func updateFlagStatus() {
        print("updateFlagStatus")
        if let flags = self.mapViewModel.gameData?.flags {
            for flag in flags {
                for annotation in mapView.annotations {
                    
                    if flag.latitude == String (annotation.coordinate.latitude),
                        flag.longitude == String (annotation.coordinate.longitude),
                        flag.activeFlg == false {
                        mapView.view(for: annotation)?.isHidden = !flag.activeFlg
                    }
                }
            }
        }
    }
    
    // MARK: EndGame
    func prepareForEndGame() {
        print("prepareForEndGame")
        stopLocalBeacon()
        stopMonitoring()
        mapViewModel.finishGame()
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEndGame" {
            if let endGameViewController = segue.destination as? EndGameViewController {
                endGameViewController.endGameDelegate = self
                endGameViewController.winCopsFlg = winCopsFlg
            }
        }
        
        if segue.identifier == "showCountdown" {
            if let countdownViewController = segue.destination as? CountdownViewController {
                countdownViewController.countdownDelegate = self
            }
        }
    }
}

// MARK: MapDelegate
extension MapViewController: MapDelegate {
    
    func didFetchGame() {
        print("didFetchGame")
        self.collectionView.reloadData()
    }
    
    func didChangeGameValues() {
        print("didChangeGameValues")
        // controll flag hidden status
        updateFlagStatus()
        let leftRobs = mapViewModel.updateRobbersLabel()
        let flagCnt = mapViewModel.updateFlagLabel()
        
        if flgCops! {
            statusNumLabel.text = leftRobs
        } else {
            statusNumLabel.text = flagCnt
            let JailStatus = mapViewModel.judgeJailStatus()
            jailImageView.isHidden = !JailStatus
            
            // Stop beacon and monitoring
            if JailStatus {
                alertLabel.text = "YOU'VE BEEN SENT TO JAIL!"
                stopLocalBeacon()
                stopMonitoring()
            }
        }
        
        // Judge game end
        if leftRobs == "0" {
            winCopsFlg = true
            prepareForEndGame()
            performSegue(withIdentifier: "showEndGame", sender: nil)
        } else if flagCnt == "0" {
            winCopsFlg = false
            prepareForEndGame()
            performSegue(withIdentifier: "showEndGame", sender: nil)
        }
    }
    
    func didCancleGame() {
        print("didCancleGame")
        let alertController = UIAlertController(title: "This game was cancelled",
                                                message: "This game was cancelled by the owner",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .cancel,
                                                handler: {(handler) in
                                                        self.prepareForEndGame()
                                                        self.backToMenu()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension MapViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var rows = 0
        
        if flgCops! {
            rows = mapViewModel.gameData?.cops.players.count ?? 0
        } else {
            rows = mapViewModel.gameData?.robbers.robPlayers.count ?? 0
        }
        
        return rows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var name = ""
        var userImage = ""
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapCollectionViewCell", for: indexPath) as! MapCollectionViewCell
        
        if flgCops! {
            name = (mapViewModel.gameData?.cops.players[indexPath.row].userName)!
            userImage = (mapViewModel.gameData?.cops.players[indexPath.row].userImageURL)!
        } else {
            name = (mapViewModel.gameData?.robbers.robPlayers[indexPath.row].userName)!
            userImage = (mapViewModel.gameData?.robbers.robPlayers[indexPath.row].userImageURL)!
        }
        cell.setCellValues(name: name, userImageURL: userImage)
        return cell
    }
}

// MARK: CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("locationManager")
        var printInfo = ""
        var alert = ""
        
        if let beacon = beacons.last {
                
            let bea = beacon as CLBeacon
            let title = "------------ number \(beacons.count) -----------------\n"
            let name = "Name: \(bea.uuid) \n"
            let major = "major: \(bea.major.intValue) \n"
            let minor = "minor: \(bea.minor.intValue) \n"
            let location = "location: \(mapViewModel.locationString(beacon: bea)) \n"
            alert = mapViewModel.alertForProximity(bea.proximity, gameUuid: bea.uuid.uuidString)
            printInfo += title + name + major + minor + location
        }
        
        print(printInfo)
        
        if alert == "Unknown" || alert == "" {
            alertLabel.isHidden = true
        } else {
            alertLabel.isHidden = false
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
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
            print(region.identifier)
            self.mapViewModel.updateFlag(identifier: region.identifier)
    }
}

// MARK: CBPeripheralManagerDelegate
extension MapViewController: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("peripheralManagerDidUpdateState")
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
    
    // Annotation setting
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "flags") as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "flags")
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.glyphText = "💰"
        
        return annotationView
    }
}


// MARK: UNUserNotificationCenterDelegate
extension MapViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    }
}

// MARK: EndGameDelegate
extension MapViewController: EndGameDelegate {
    func backToMenu() {
        print("backToMenu")
        self.navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: CountdownDelegate
extension MapViewController: CountdownDelegate {
    func startGame() {
        print("startGame")
        // Monitaring setting
        startMonitoringUser()
        initLocalBeacon(gameUuid: myGameUuid!)
    }
}
