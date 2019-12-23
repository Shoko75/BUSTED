//
//  AppDelegate.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-10.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var locationManager: CLLocationManager?
    var notificationCenter: UNUserNotificationCenter?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        // Firebase setting
        FirebaseApp.configure()
        
        // Notification setting
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        
        self.notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter?.delegate = self as! UNUserNotificationCenterDelegate
        
        let options: UNAuthorizationOptions = [.alert, .sound]
        
        notificationCenter?.requestAuthorization(options: options, completionHandler: { (granted, error) in
            if !granted {
                print("Permission not granted")
            }
        })
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // Notification setiing
    func handleEvent(forRegion region: CLRegion) {
        
        let content = UNMutableNotificationContent()
        content.title = "Cops and Robbers (Warning)"
        content.body = "You are out side of the filed! Please come back! "
        content.sound = UNNotificationSound.default
        
        let timeInSeconds: TimeInterval = 5
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInSeconds, repeats: false)
        let identifier = region.identifier
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter?.add(request, withCompletionHandler: { (error) in
            if error != nil {
                print("Error adding notification with identifier: \(identifier)")
            }
        })
    }

}

// MARK: CLLocationManagerDelegate
extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            self.handleEvent(forRegion: region)
        }
    }
    
}

// MARK: UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Setting for foreground notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    // Setting for when the user tapped the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let identifier = response.notification.request.identifier
    }
}
