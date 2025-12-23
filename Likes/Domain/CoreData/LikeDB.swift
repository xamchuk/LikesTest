//
//  LikeDB.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 22.12.2025.
//

import CoreData

extension LikeEntity {
    init(managedObject: LikeDB) {
        self.id = managedObject.id ?? ""
        self.name = managedObject.name ?? ""
        self.previewImageURL = managedObject.previewImageURL ?? ""
        self.images = JSONCoding.decodeStrings(managedObject.images)

        self.isSameGoal = managedObject.isSameGoal
        self.isQuickReply = managedObject.isQuickReply

        self.isLiked = managedObject.isLiked
        self.lastUpdated = Int(managedObject.lastUpdated)
    }
}

extension LikeDB {
    func apply(_ entity: LikeEntity) {
        self.id = entity.id
        self.name = entity.name
        self.previewImageURL = entity.previewImageURL
        self.images = JSONCoding.encodeStrings(entity.images)

        self.isSameGoal = entity.isSameGoal
        self.isQuickReply = entity.isQuickReply

        self.isLiked = entity.isLiked
        self.lastUpdated = Int64(entity.lastUpdated)
    }
}
