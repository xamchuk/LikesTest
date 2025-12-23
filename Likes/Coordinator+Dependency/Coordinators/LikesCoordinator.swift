//
//  LikesCoordinator.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 21.12.2025.
//

import UIKit

protocol LikesCoordinatorProtocol: Coordinator {
   
}

final class LikesCoordinator {
    
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

// MARK: - LikesCoordinatorProtocol -
extension LikesCoordinator: LikesCoordinatorProtocol {
   
    func start() {
        let vc = dependency.likes(coordinator: self)
        self.presenter.pushViewController(vc, animated: false)
    }
}
