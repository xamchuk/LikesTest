//
//  LikeItem.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 22.12.2025.
//

struct LikeEntity: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
    let previewImageURL: String
    let images: [String]
   
    let isSameGoal: Bool
    let isQuickReply: Bool
   
    var isLiked: Bool = false
    var lastUpdated: Int
    var isDiscard: Bool = false
}

extension LikeEntity {
   // var content: 
}
