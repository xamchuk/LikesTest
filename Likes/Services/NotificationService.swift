//
//  NotificationService.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 23.12.2025.
//

import Foundation
import NotificationCenter


// Better way to not use singleton - but inject NotificationService to that class where it needs. To save a bit time - I'm using singleton
protocol NotificationServiceType: AnyObject {
    func setOnNewLike(name: String)
}

final class NotificationService: NSObject {
    
    // MARK: - Singleton -
    static var shared = NotificationService()
    
    // MARK: - Services -
    private let notificationsCenter = UNUserNotificationCenter.current()

    // MARK: - Properties -
    var onNewMessageTap: ((Int) -> Void)?
    
    // MARK: - Init -
    override private init() {
        super.init()
        notificationsCenter.delegate = self
        requestAuthorisation()
    }
    
    func requestAuthorisation(completion:  ((Bool) -> Void)? = nil) {
        notificationsCenter.requestAuthorization(options: [.alert, .badge, .sound, .providesAppNotificationSettings]) { isGranted, _ in
            completion?(isGranted)
        }
    }
    
    func registerForRemoteNotification(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        application.registerForRemoteNotifications()
    
        /// 3) If app launched by tapping a push while TERMINATED, read payload here
        if let remote = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
            handleRemoteNotification(userInfo: remote, launchedFromColdStart: true)
        }
    }
    
    
    private func createNotification(item: NotificationItem) {
        guard item.interval > 0 else { return }
      
        
        let content = UNMutableNotificationContent()
        content.title = item.title
        content.body = item.subtitle
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: item.interval, repeats: false)
        let request = UNNotificationRequest(identifier: item.id,
                                            content: content,
                                            trigger: trigger)
        
        notificationsCenter.add(request)
    }
}

// MARK: - UNUserNotificationCenterDelegate -
extension NotificationService: UNUserNotificationCenterDelegate {
   
    /// Receive remote notifications in Active mode - show banner
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        handleRemoteNotification(userInfo: userInfo, launchedFromColdStart: false)
        
        completionHandler([.sound, .badge, .banner, .list])
    }
    
    /// Tap on banner
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
      
        if response.notification.request.identifier == "like_id" {
            onNewMessageTap?(2)
        }
       
        completionHandler()
    }
    
    func handleRemoteNotification(userInfo: [AnyHashable: Any], launchedFromColdStart: Bool) {
     
    }
}


// MARK: - NotificationServiceType -
extension NotificationService: NotificationServiceType {
    func setOnNewLike(name: String) {
        createNotification(item: .init(id: "like_id",
                                       title: "New Connections",
                                       subtitle: "\(name) is waiting for you!",
                                       interval: 3)
        )
    }
}
