//
//  MatchesCoordinator.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 21.12.2025.
//

import UIKit

protocol MatchesCoordinatorProtocol: Coordinator {
   
}

final class MatchesCoordinator {
    
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

// MARK: - MatchesCoordinatorProtocol -
extension MatchesCoordinator: MatchesCoordinatorProtocol {
   
    func start() {
        let vc = dependency.matches(coordinator: self)
        self.presenter.pushViewController(vc, animated: false)
    }
}
