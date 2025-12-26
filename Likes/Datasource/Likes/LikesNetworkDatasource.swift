//
//  LikesNetworkDatasource.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 22.12.2025.
//

import Combine
import Foundation

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
    func subscribeLikes(userId: String) -> AnyPublisher<LikeEntity, AppError> {
        network.connect(url: URL(string: "https://google.com")!, headers: [:])
    }
    
    func onDidLike(id: String, isSynced: Bool = true) -> AnyPublisher<(), AppError> {
        network.mockLikeDidSet(for: id)
    }
    
    func onDidDiscard(id: String, isFail: Bool = false) -> AnyPublisher<(), AppError> {
        network.mockDiscardDidSet(for: id)
    }
    
    func loadFailed() -> [LikeEntity] {
        assertionFailure("should not be called from network datasource")
        return []
    }
    
    func load() -> [LikeEntity] {
        assertionFailure("should not be called from network datasource")
        return []
    }
    
    func delete(id: String) {
        assertionFailure("should not be called from network datasource")
    }
    
    func save(_ like: LikeEntity) {
        assertionFailure("should not be called from network datasource")
    }
    
    func loadLikes(after id: String?, pageSize: Int) -> AnyPublisher<[LikeEntity], AppError> {
        network.mockRequestGet(after: id, pageSize: pageSize)
    }
}
