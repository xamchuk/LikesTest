//
//  LikesNetworkDatasource.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 22.12.2025.
//

import Combine

final class LikesNetworkDatasource {
    
    // MARK: - Network -
    private let network: Network
    
    // MARK: - Init -
    init(network: Network) {
        self.network = network
    }
}

// MARK: - LikesDatasourceType -
extension LikesNetworkDatasource: LikesDatasourceType {
    func onDidLike(id: String, isSynced: Bool = true) -> AnyPublisher<(), AppError> {
        network.mockLikeDidSet(for: id)
    }
    
    func onDidDiscard(id: String, isFail: Bool = false) -> AnyPublisher<(), AppError> {
        network.mockDiscardDidSet(for: id)
    }
    
    func loadFailed() -> [LikeEntity] {
        []
    }
    
    func load() -> [LikeEntity] {
        assertionFailure()
        return []
    }
    
    func save(_ like: LikeEntity) {}
    
    func loadLikes(after id: String?, pageSize: Int) -> AnyPublisher<[LikeEntity], AppError> {
        network.mockRequestGet(after: id, pageSize: pageSize)
    }
}
