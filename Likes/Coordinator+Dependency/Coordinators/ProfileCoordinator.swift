//
//  ProfileCoordinator.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 21.12.2025.
//

import UIKit

protocol ProfileCoordinatorProtocol: Coordinator {
   
}

final class ProfileCoordinator {
    
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

// MARK: - ProfileCoordinatorProtocol -
extension ProfileCoordinator: ProfileCoordinatorProtocol {
   
    func start() {
        let vc = dependency.profile(coordinator: self)
        self.presenter.pushViewController(vc, animated: false)
    }
}
