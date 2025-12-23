//
//  RedirectService.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 21.12.2025.
//

import UIKit

final class RedirectService {
    
    // MARK: - Coordinator -
 //   private var coordinator: DashboardCoordinatorProtocol?
    
    // MARK: - Public -
    func start() {
        AppDelegate.shared.window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = AppDelegate.shared.window else { fatalError() }
        
        showSplashScreen()
    }
    
    // MARK: - Private -
    private func showSplashScreen() {
        let splashVC = SplashViewController(onDataLoaded: { [weak self] isBlocked in
            self?.showHomeScreen(isLikesBlocked: isBlocked)
        })
        let options: UIView.AnimationOptions = .transitionCurlUp
        let duration: TimeInterval = 0
        guard let window = AppDelegate.shared.window else { fatalError() }

        UIView.transition(with: window, duration: duration, options: options, animations: {
            AppDelegate.shared.window?.rootViewController = splashVC
            AppDelegate.shared.window?.makeKeyAndVisible()
        })
    }
    
    private func showHomeScreen(isLikesBlocked: Bool) {
        
        let vc = TabBarViewController
            .init(dependencyProvider: DependencyProvider(isLikesBlocked: isLikesBlocked))
        
        let options: UIView.AnimationOptions = .curveEaseInOut
        let duration: TimeInterval = 0.5
        guard let window = AppDelegate.shared.window else { fatalError() }
        UIView.transition(with: window, duration: duration, options: options, animations: {
            AppDelegate.shared.window?.rootViewController = vc
            AppDelegate.shared.window?.makeKeyAndVisible()
        })
    }
    
    deinit {
        print("\(self) deinited")
    }
}
