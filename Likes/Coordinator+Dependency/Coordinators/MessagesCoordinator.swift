//
//  MessagesCoordinator.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 21.12.2025.
//

import UIKit

protocol MessagesCoordinatorProtocol: Coordinator {
   
}

final class MessagesCoordinator {
    
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

// MARK: - MessagesCoordinatorProtocol -
extension MessagesCoordinator: MessagesCoordinatorProtocol {
   
    func start() {
        let vc = dependency.messages(coordinator: self)
        self.presenter.pushViewController(vc, animated: false)
    }
}
