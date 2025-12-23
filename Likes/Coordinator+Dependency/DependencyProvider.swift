//
//  DependencyProvider.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 21.12.2025.
//

import UIKit

protocol DependencyProviderProtocol: AnyObject {
    func feed(coordinator: FeedCoordinatorProtocol) -> UIViewController
    func messages(coordinator: MessagesCoordinatorProtocol) -> UIViewController
    func matches(coordinator: MatchesCoordinatorProtocol) -> UIViewController
    func likes(coordinator: LikesCoordinatorProtocol) -> UIViewController
    func profile(coordinator: ProfileCoordinatorProtocol) -> UIViewController
}

final class DependencyProvider {
    
    // MARK: - UseCases -
    private let likesUseCase: LikesUseCaseType
    
    // MARK: - Properties
    var isLikesBlocked: Bool // It should be in some settings use case or smt. I'm taking it from splash, imitating coming this flag from server
    
    // MARK: - Init -
    init(isLikesBlocked: Bool) {
        self.isLikesBlocked = isLikesBlocked
        let likesLocalDatasource = LikesLocalDatasource(container: CoreDataStack.shared.container)
        let likesNetworkDatasource = LikesNetworkDatasource(network: NetworkService())
        self.likesUseCase = LikesUseCase(networkDatasource: likesNetworkDatasource,
                                         localDatasource: likesLocalDatasource)
    }
    
}

// MARK: - DependencyProviderProtocol -
extension DependencyProvider: DependencyProviderProtocol {
    func feed(coordinator: FeedCoordinatorProtocol) -> UIViewController {
        let vc = FeedViewController(coordinator: coordinator)
        return vc
    }
    
    func messages(coordinator: MessagesCoordinatorProtocol) -> UIViewController {
        let vc = MessagesViewController(coordinator: coordinator)
        return vc
    }
    
    func matches(coordinator: MatchesCoordinatorProtocol) -> UIViewController {
        let viewModel = MatchesViewModel(likesUseCase: self.likesUseCase)
        let vc = MatchesViewController(viewModel: viewModel,
                                       coordinator: coordinator)
        return vc
    }
    
    func likes(coordinator: LikesCoordinatorProtocol) -> UIViewController {
        let viewModel = LikesViewModel(useCase: self.likesUseCase,
                                       isLikesBlocked: self.isLikesBlocked)
        let vc = LikesViewController(viewModel: viewModel,
                                     coordinator: coordinator)
        return vc
    }
    
    func profile(coordinator: ProfileCoordinatorProtocol) -> UIViewController {
        let vc = ProfileViewController(coordinator: coordinator)
        return vc
    }
}
