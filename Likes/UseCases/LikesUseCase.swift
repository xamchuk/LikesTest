//
//  LikesUseCase.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 22.12.2025.
//

import Combine

protocol LikesUseCaseType: AnyObject {
    
    var likes: CurrentValueSubject<[LikeEntity], Never> { get }
    
    func fetchLikes(after id: String?, pageSize: Int) -> AnyPublisher<(), AppError>
    func onLike(id: String) -> AnyPublisher<(), AppError>
    func onDiscard(id: String) -> AnyPublisher<(), AppError>
    func syncFailed() -> AnyPublisher<(), Never>
}


final class LikesUseCase {
    
    // MARK: - Datasource -
    private let networkDatasource: LikesDatasourceType
    private let localDatasource: LikesDatasourceType
    
    // MARK: - Properties -
    var likes: CurrentValueSubject<[LikeEntity], Never>
    
    // MARK: - Init -
    init(networkDatasource: LikesDatasourceType,
         localDatasource: LikesDatasourceType) {
        self.networkDatasource = networkDatasource
        self.localDatasource = localDatasource
        
        /// We can load cached data, but we need to think here about.
        /// If data outdated, of not relevant at all.
        /// Or maybe user do not have access anymore
        likes = .init([])//localDatasource.load()
    }
}

// MARK: - LikesUseCaseType -
extension LikesUseCase: LikesUseCaseType {
    func fetchLikes(after id: String?, pageSize: Int) -> AnyPublisher<(), AppError> {
        networkDatasource.loadLikes(after: id, pageSize: pageSize)
            .handleEvents(receiveOutput: { [weak self] likesFromServer in
                guard let self else { return }
              
                // Filter unsynced items from response
                var likesFromServer = likesFromServer
                let localFailed = localDatasource.loadFailed()
                if !localFailed.isEmpty {
                    let discardedIds = Set(localFailed.filter { $0.isDiscard }.map { $0.id })
                      let likedIds = Set(localFailed.filter { $0.isLiked }.map { $0.id })

                      if !discardedIds.isEmpty {
                          likesFromServer.removeAll { discardedIds.contains($0.id) }
                      }

                      if !likedIds.isEmpty {
                          for i in likesFromServer.indices {
                              if likedIds.contains(likesFromServer[i].id) {
                                  likesFromServer[i].isLiked = true
                              }
                          }
                      }
                }
                
                if self.likes.value.isEmpty {
                    self.likes.send(likesFromServer)
                } else {
                    self.likes.value += likesFromServer
                }
                
                likesFromServer.forEach { like in
                    self.localDatasource.save(like)
                }
            })
            .map({  _ in () })
            .eraseToAnyPublisher()
           
    }
    
    func onLike(id: String) -> AnyPublisher<(), AppError> {
        return networkDatasource.onDidLike(id: id, isSynced: true)
            .flatMap { [localDatasource] _ in
                localDatasource.onDidLike(id: id, isSynced: true)
            }
            .catch { [localDatasource] _ in
                localDatasource.onDidLike(id: id, isSynced: false)
            }
            .handleEvents(receiveOutput: { [weak self] _ in
                if let index = self?.likes.value.firstIndex(where: { $0.id == id }) {
                    self?.likes.value[index].isLiked = true
                }
            })
            .eraseToAnyPublisher()
    }
    
    
    /// example of error response from server:
    /// we catch error, store correct result to database
    /// also we need sync this request with next time
    func onDiscard(id: String) -> AnyPublisher<(), AppError> {
        return networkDatasource.onDidDiscard(id: id, isFail: false)
            .flatMap { [localDatasource] _ in
                localDatasource.onDidDiscard(id: id, isFail: false)
            }
            .catch { [localDatasource] _ in
                localDatasource.onDidDiscard(id: id, isFail: true)
            }
            .handleEvents(receiveOutput: { [weak self] _ in
                if let index = self?.likes.value.firstIndex(where: { $0.id == id }) {
                    self?.likes.value.remove(at: index)
                }
            })
            .eraseToAnyPublisher()
    }
    
    /// Method to sync failed requests with server
    /// We can call it from some screen events or with each requests
    /// It's just an example, so I will call it from UI, basically once per app launch
    func syncFailed() -> AnyPublisher<(), Never> {
        let failedItems = localDatasource.loadFailed()
        guard !failedItems.isEmpty else {
            return Just(())
                .eraseToAnyPublisher()
        }

        let tasks: [AnyPublisher<Void, AppError>] = failedItems.compactMap { item in
            if item.isLiked { return onLike(id: item.id) }
            if item.isDiscard { return onDiscard(id: item.id) }
            return nil
        }

        return tasks.reduce(
            Just(())
                .eraseToAnyPublisher()
        ) { chain, next in
            chain.flatMap { next }
                .replaceError(with: ())
                .eraseToAnyPublisher()
        }
    }
}
