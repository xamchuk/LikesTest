//
//  TabBarViewController.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 21.12.2025.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    // MARK: - UIConstants -
    private let tabHeight: Double = 84
    
    // MARK: - Tabs -
    private var homeVC: UIViewController!
    private var swipePhotosVC: UIViewController!
    private var contactsVC: UIViewController!
    private var settingsVC: UIViewController!
    
    // MARK: - Coordinator -
    private var coordinator: TabCoordinatorProtocol
    
    // MARK: - Properties -
    private var heightDidSet = false
   
    // MARK: - Init -
    init(dependencyProvider: DependencyProviderProtocol) {
        self.coordinator = TabCoordinator(dependencyProvider: dependencyProvider)
        super.init(nibName: nil, bundle: nil)
        
        setupTabs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle -
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        heightDidSet = true
        viewDidLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Set custom height of tab bar
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return  }
            guard !self.heightDidSet else { return }
            self.tabBar.frame.size.height = tabHeight
            self.tabBar.frame.origin.y = self.view.frame.height - tabHeight
        }
    }
    
    // MARK: - Setup Methods -
    private func setupTabs() {
        self.delegate = self
            
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()

        appearance.stackedLayoutAppearance.normal.iconColor = .lGrey.withAlphaComponent(0.29)
        
        tabBar.standardAppearance = appearance
        
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.barTintColor = .clear
     
        tabBar.layer.backgroundColor = UIColor.clear.cgColor
        tabBar.backgroundColor = .lWhite
        tabBar.tintColor = .lBlack
        
        let feedVC = coordinator.startFeed()
        let messagesVC = coordinator.startMessages()
        let matchesVC = coordinator.startMatches()
        let likesVC = coordinator.startLikes()
        let profileVC = coordinator.startProfile()

        likesVC.tabBarItem.badgeValue = "2"
        setViewControllers([feedVC,
                            messagesVC,
                            matchesVC,
                            likesVC,
                            profileVC,],
                           animated: false)
        self.selectedIndex = 3
        
        for tab in self.tabBar.items ?? [] {
            tab.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
            tab.badgeColor = .lRed
        }
        
        NotificationService.shared.onNewMessageTap = { [weak self] index in
            self?.selectedIndex = index
        }
    }
}

// MARK: - UITabBarControllerDelegate -
extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

    }
}


