//
//  CoreDataStack.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 22.12.2025.
//

import CoreData

final class CoreDataStack {

    static let shared = CoreDataStack()

    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "Likes")

        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Core Data load error: \(error)")
            }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
