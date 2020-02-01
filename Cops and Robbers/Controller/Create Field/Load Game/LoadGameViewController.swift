//
//  LoadGameViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-29.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit
import CoreLocation

class LoadGameViewController: UIViewController {
    
    
    var loadGameViewModel:LoadGameViewModel!
    var passedData = [Player]()
    var flgAdmin = false
    var gameID: String?
    var feildLocation: DBField?
    var locationManager: CLLocationManager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGameViewModel = LoadGameViewModel()
        loadGameViewModel.loadGameDelegate = self
        loadGameViewModel.observeOccupiedMajor()
        
        // Location Manager setting
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        if CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            activateLocationServices()
        } else {
            locationManager?.requestWhenInUseAuthorization()
        }
        
        guard let gameID = gameID else { return }
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (timer) in
            self.loadGameViewModel.prepareForGame(currentLoction: self.feildLocation!, playersInfo: self.passedData, gameID: gameID)
        }
    }
    
    func activateLocationServices() {
        locationManager?.startUpdatingLocation()
    }
}

// CLLocationManagerDelegate
extension LoadGameViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            activateLocationServices()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last!
        
        let lan = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        
        feildLocation = DBField(latitude: String(lan), longitude: String(lon))
    }
}

extension LoadGameViewController: LoadGameDelegate {
    func didCreateGame() {
        performSegue(withIdentifier: "showMakeTeam", sender: nil)
    }
}
