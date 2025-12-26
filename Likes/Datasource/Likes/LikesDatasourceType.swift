//
//  LikesDatasourceType.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 22.12.2025.
//

import Combine

protocol LikesDatasourceType: AnyObject {
    func loadLikes(after id: String?, pageSize: Int) -> AnyPublisher<[LikeEntity], AppError>
    func onDidLike(id: String, isSynced: Bool) -> AnyPublisher<(), AppError>
    func onDidDiscard(id: String, isFail: Bool) -> AnyPublisher<(), AppError>
    func loadFailed() -> [LikeEntity]
    func save(_ like: LikeEntity)
    func subscribeLikes(userId: String) -> AnyPublisher<LikeEntity, AppError>
    func delete(id: String)
}
