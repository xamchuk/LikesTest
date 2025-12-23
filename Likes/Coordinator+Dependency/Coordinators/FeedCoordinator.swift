//
//  FeedCoordinator.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 21.12.2025.
//

import UIKit

protocol FeedCoordinatorProtocol: Coordinator {
   
}

final class FeedCoordinator {
    
    // MARK: - Presenter -
    var presenter: UINavigationController
    
    // MARK: - Dependency -
    private let dependency: DependencyProviderProtocol
    
    // MARK: - Init -
    init(presenter: UINavigationController, dependency: DependencyProviderProtocol) {
        self.presenter = presenter
        self.dependency = dependency
    }
}

// MARK: - FeedCoordinatorProtocol -
extension FeedCoordinator: FeedCoordinatorProtocol {
   
    func start() {
        let vc = dependency.feed(coordinator: self)
        self.presenter.pushViewController(vc, animated: false)
    }
}
