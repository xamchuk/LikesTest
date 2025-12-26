//
//  LikesViewModel.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 22.12.2025.
//

import Combine

protocol LikesViewModelType: AnyObject {
    var likedYouItems: AnyPublisher<[LikesCollectionCell.Content], Never> { get }
    var likedSentItems: AnyPublisher<[LikesCollectionCell.Content], Never> { get }
    var isLikesBlocked: CurrentValueSubject<Bool, Never> { get }
   
    func onNextPage(id: String?) -> AnyPublisher<(), AppError>
    func onLike(id: String) -> AnyPublisher<(), AppError>
    func onDiscard(id: String) -> AnyPublisher<(), AppError>
    func syncFailed() -> AnyPublisher<(), Never>
    func onUnblur() -> AnyPublisher<TimerUIItem.Output, Never>
    func subscribeLikes() -> AnyPublisher<(), AppError>
}


final class LikesViewModel {
    
    // MARK: - Use Case, Services -
    private let useCase: LikesUseCaseType
    private var timer: CountdownTimerService?
    
    // MARK: - Properties -
    private(set) var isLikesBlocked: CurrentValueSubject<Bool, Never>
    var likedYouItems: AnyPublisher<[LikesCollectionCell.Content], Never> {
        useCase.likes.map({ likes in
            let filtered = likes.compactMap({ $0.isLiked ? nil : MapEntitiesService.map(like: $0) })
            
            return filtered
        }).eraseToAnyPublisher()
    }
    
    var likedSentItems: AnyPublisher<[LikesCollectionCell.Content], Never> {
        useCase.likes.map({ likes in
            let filtered = likes.compactMap({ $0.isLiked ? MapEntitiesService.map(like: $0) : nil })
            return filtered
        }).eraseToAnyPublisher()
    }
   
    // MARK: - Init -
    init(useCase: LikesUseCaseType, isLikesBlocked: Bool) {
        self.useCase = useCase
        self.isLikesBlocked = .init(isLikesBlocked)
    }
}

// MARK: - LikesViewModelType -
extension LikesViewModel: LikesViewModelType {
    func onLike(id: String) -> AnyPublisher<(), AppError> {
        
        return useCase.onLike(id: id)
    }
    
    func onDiscard(id: String) -> AnyPublisher<(), AppError> {
        useCase.onDiscard(id: id)
    }
    
    func onNextPage(id: String?) -> AnyPublisher<(), AppError> {
        useCase.fetchLikes(after: id, pageSize: 6)
    }
    
    func syncFailed() -> AnyPublisher<(), Never> {
        useCase.syncFailed()
    }
    
    func onUnblur() -> AnyPublisher<TimerUIItem.Output, Never> {
        self.timer = .init(seconds: 120)
        self.timer?.start()
        self.isLikesBlocked.send(false)
        return timer!.output
            .eraseToAnyPublisher()
    }
    
    func subscribeLikes() -> AnyPublisher<(), AppError> {
        useCase.subscribeLikes()
    }
}
