//
//  AppDelegate.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 21.12.2025.
//

import UIKit
//import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Singleton -
    static var shared = AppDelegate()
    
    // MARK: - Window -
    var window: UIWindow?
  
    // MARK: - Services -
    var redirectService = RedirectService()
 
    // MARK: - Methods -
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
   
        start()
      
        return true
    }
}

// MARK: - Private -
extension AppDelegate {
    private func start() {
        redirectService = RedirectService()
        redirectService.start()
    }
}
