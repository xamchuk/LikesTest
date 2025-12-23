//
//  MapEntitiesService.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 23.12.2025.
//

struct MapEntitiesService {
    static func map(like: LikeEntity) -> LikesCollectionCell.Content {
        .init(id: like.id,
              mainImage: like.previewImageURL,
              photosCount: like.images.count,
              isSameGoal: like.isSameGoal,
              isQuickReply: like.isQuickReply,
              name: like.name)
    }
}

