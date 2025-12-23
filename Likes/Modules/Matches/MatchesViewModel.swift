//
//  MatchesViewModel.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 23.12.2025.
//

import Combine

protocol MatchesViewModelType: AnyObject {
    var likedSentItems: AnyPublisher<[LikesCollectionCell.Content], Never> { get }
}

final class MatchesViewModel {
    
    // MARK: - Use Cases -
    private let likesUseCase: LikesUseCaseType
    
    // MARK: - Properties -
    var likedSentItems: AnyPublisher<[LikesCollectionCell.Content], Never> {
        likesUseCase.likes
            .share()
            .map({ likes in
            likes.compactMap({ $0.isLiked ? MapEntitiesService.map(like: $0) : nil  })
        }).eraseToAnyPublisher()
    }
    
    init(likesUseCase: LikesUseCaseType) {
        self.likesUseCase = likesUseCase
    }
}

// MARK: - MatchesViewModelType -
extension MatchesViewModel: MatchesViewModelType {
    
}
