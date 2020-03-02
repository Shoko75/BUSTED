//
//  LoadGameViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-29.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit
import CoreLocation
import Lottie

class LoadGameViewController: UIViewController {
    
    @IBOutlet weak var animationUIView: UIView!
    
    let animationView = AnimationView()
    
    private var loadGameViewModel = LoadGameViewModel()
    
    var passedData = [Player]()
    var flgAdmin = false
    var gameID: String?
    var feildLocation: CLLocation?
    var locationManager: CLLocationManager?
    
    // MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start Animation
        playAnimation()
        
        // Delegate
        loadGameViewModel.loadGameDelegate = self
        
        if flgAdmin {
            
            // get OccupiedMajor data
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
            
            // create game after 5 sec
            guard let gameID = gameID else { return }
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (timer) in
                self.loadGameViewModel.prepareForGame(currentLoction: self.feildLocation!, playersInfo: self.passedData, gameID: gameID)
            }
            
        } else {
            guard let gameID = gameID else { return }
            loadGameViewModel.observeGame(gameID: gameID)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {

        animationView.play(fromProgress: 0,
                           toProgress: 1,
                           loopMode: LottieLoopMode.autoReverse,
                           completion: { (finished) in
                            if finished {
                                print("Animation Complete")
                            } else {
                                print("Animation cancelled")
                            }
        })
    }
    
    func playAnimation() {
        let animation = Animation.named("1802-single-wave-loader")
        animationView.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        animationView.animation = animation

        animationView.contentMode = .scaleAspectFill

        self.animationUIView.addSubview(animationView)

    }
    
    func activateLocationServices() {
        locationManager?.startUpdatingLocation()
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.loadGameViewController.showTeam.identifier {
            if let showTeamViewController = segue.destination as? ShowTeamViewController {
                showTeamViewController.gameID = gameID!
            }
        }
    }
}

// MARK: CLLocationManagerDelegate
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
        
        self.feildLocation = CLLocation(latitude: lan, longitude: lon)
    }
}

// MARK: LoadGameDelegate
extension LoadGameViewController: LoadGameDelegate {
    func didCreateGame() {
        self.loadGameViewModel.stopObserveGame(gameID: gameID!)
        performSegue(withIdentifier: R.segue.loadGameViewController.showTeam, sender: nil)
    }
}
