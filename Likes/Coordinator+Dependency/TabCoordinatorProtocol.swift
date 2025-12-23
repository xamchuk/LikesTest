//
//  TabCoordinatorProtocol.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 21.12.2025.
//


import Foundation
import UIKit

protocol TabCoordinatorProtocol: AnyObject {
    func startFeed() -> UIViewController
    func startMessages() -> UIViewController
    func startMatches() -> UIViewController
    func startLikes() -> UIViewController
    func startProfile() -> UIViewController
}

final class TabCoordinator {
    
    // MARK: - Provider -
    private let dependencyProvider: DependencyProviderProtocol
    
    // MARK: - Coordinators -
    private var feedCoordinator: FeedCoordinatorProtocol?
    private var messagesCoordinator: MessagesCoordinatorProtocol?
    private var matchesCoordinator: MatchesCoordinatorProtocol?
    private var likesCoordinator: LikesCoordinatorProtocol?
    private var profileCoordinator: ProfileCoordinatorProtocol?
    
        // MARK: - Init -
    init(dependencyProvider: DependencyProviderProtocol) {
        self.dependencyProvider = dependencyProvider
    }
    
    // MARK: - Private -
    private func createNavigation() -> UINavigationController {
        let navigation = UINavigationController()
        navigation.setNavigationBarHidden(true, animated: false)
        return navigation
    }
    
}

// MARK: - TabCoordinatorProtocol -
extension TabCoordinator: TabCoordinatorProtocol {
    func startFeed() -> UIViewController {
        let navigation = createNavigation()
        feedCoordinator = FeedCoordinator(presenter: navigation,
                                          dependency: dependencyProvider)
        navigation.setupForTab(image: .tabFeed, selectedImage: .tabFeed)
        
        feedCoordinator?.start()
        
        return navigation
    }
    
    func startMessages() -> UIViewController {
        let navigation = createNavigation()
        messagesCoordinator = MessagesCoordinator(presenter: navigation,
                                                  dependency: dependencyProvider)
        navigation.setupForTab(image: .tabMessages, selectedImage: .tabMessages)
        messagesCoordinator?.start()
        return navigation
    }
    
    func startMatches() -> UIViewController {
        let navigation = createNavigation()
        matchesCoordinator = MatchesCoordinator(presenter: navigation,
                                                dependency: dependencyProvider)
        navigation.setupForTab(image: .tabMatches, selectedImage: .tabMatches)
        matchesCoordinator?.start()
        return navigation
    }
    
    func startLikes() -> UIViewController {
        let navigation = createNavigation()
        likesCoordinator = LikesCoordinator(presenter: navigation,
                                            dependency: dependencyProvider)
        navigation.setupForTab(image: .tabLikes, selectedImage: .tabLikes)
        likesCoordinator?.start()
        return navigation
    }
    
    func startProfile() -> UIViewController {
        let navigation = createNavigation()
        profileCoordinator = ProfileCoordinator(presenter: navigation,
                                                dependency: dependencyProvider)
        navigation.setupForTab(image: .tabProfile, selectedImage: .tabProfile)
        profileCoordinator?.start()
        return navigation
    }
}
