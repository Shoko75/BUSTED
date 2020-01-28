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

    let gcmMessageIDKey = "gcm.message_id"
    let categoryButtonsId = "JoinOrDecline"
    
    enum ActionButtonsId: String { case join, decline }
    
    var gameID = String()
    var window: UIWindow?
    var locationManager: CLLocationManager?
    var notificationCenter: UNUserNotificationCenter?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        // Firebase setting
        FirebaseApp.configure()
        
        // Cloud messaging setting
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        
        // Notification setting
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        
        self.notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter?.delegate = self as UNUserNotificationCenterDelegate
        
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
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo["gcm.message_id"] {
            print("3 Message ID: \(messageID)")
        }
        
        if let gameID = userInfo["gameID"] {
            self.gameID = gameID as! String
        }
        
        completionHandler([.alert])
    }
    
    // Setting for when the user tapped the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        defer { completionHandler() }
        
        
        let identity = response.notification.request.content.categoryIdentifier
        guard identity == categoryButtonsId,
            let action = ActionButtonsId(rawValue: response.actionIdentifier) else { return }
        
        if Auth.auth().currentUser != nil {
            let gameRef = Database.database().reference(withPath: "game")
            let userID = Auth.auth().currentUser?.uid
            
            switch action {
            case .join:
                let updateStatus = ["status": "Joined"]
                
                gameRef.child(gameID).child("member").child(userID!).updateChildValues(updateStatus)
                // Todo: Do it later open window
            case .decline:
                let updateStatus = ["status": "Declined"]
                
                gameRef.child(gameID).child("member").child(userID!).updateChildValues(updateStatus)
                break
            }
        } else {
            // Todo: Do it later open window
        }
        
        
       // let identifier = response.notification.request.identifier
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {

      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("1 Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("2 Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        // set fcmToken in the UserDefaults
        UserDefaults.standard.set(fcmToken, forKey: "FCM_TOKEN")
        UserDefaults.standard.synchronize()
        print("Firebase registration token: \(fcmToken)")
        registerCustomActions()
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
}
