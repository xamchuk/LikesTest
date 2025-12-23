//
//  LikesLocalDatasource.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 22.12.2025.
//

import Combine
import CoreData

import Foundation

enum JSONCoding {
    static func encodeStrings(_ value: [String]) -> Data {
        (try? JSONEncoder().encode(value)) ?? Data()
    }
    
    static func decodeStrings(_ data: Data?) -> [String] {
        guard let data, !data.isEmpty else { return [] }
        return (try? JSONDecoder().decode([String].self, from: data)) ?? []
    }
}

final class LikesLocalDatasource {
    
    // MARK: - Core Data Container -
    private let container: NSPersistentContainer
    
    // MARK: - Init -
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    // MARK: - Private -
    func fetchOrCreate(id: String, in context: NSManagedObjectContext) throws -> LikeDB {
        let req: NSFetchRequest<LikeDB> = LikeDB.fetchRequest()
        req.fetchLimit = 1
        req.predicate = NSPredicate(format: "id == %@", id)
        
        if let existing = try context.fetch(req).first {
            return existing
        }
        
        let created = LikeDB(context: context)
        created.id = id
        return created
    }
    
    func fetchLastUpdated(for id: String?, in context: NSManagedObjectContext) throws -> Int64? {
        guard let id else { return nil }
        let req: NSFetchRequest<LikeDB> = LikeDB.fetchRequest()
        req.fetchLimit = 1
        req.predicate = NSPredicate(format: "id == %@", id)
        return try context.fetch(req).first?.lastUpdated
    }
    
    func updateLike(id: String, isSynced: Bool) -> AnyPublisher<(), AppError> {
        Deferred {
            Future { [weak self] promise in
                guard let self else { return }
                
                self.container.performBackgroundTask { context in
                    do {
                        let mo = try self.fetchOrCreate(id: id, in: context)
                        mo.isLiked = true
                        mo.lastUpdated = Int64(Date().timeIntervalSince1970) // or keep your logic
                        mo.isSynced = isSynced
                        try context.save()
                        promise(.success(()))
                    } catch {
                        promise(.failure(.custom(error.localizedDescription)))                       }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateDiscard(id: String) -> AnyPublisher<(), AppError> {
        Deferred {
            Future { [weak self] promise in
                guard let self else { return }
                
                self.container.performBackgroundTask { context in
                    do {
                        let mo = try self.fetchOrCreate(id: id, in: context)
                        mo.isDiscard = true
                        mo.isSynced = false
                        mo.lastUpdated = Int64(Date().timeIntervalSince1970) // or keep your logic
                        
                        try context.save()
                        promise(.success(()))
                    } catch {
                        promise(.failure(.custom(error.localizedDescription)))                       }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // If you want real delete:
    func delete(id: String) -> AnyPublisher<Void, AppError> {
        Deferred {
            Future { [weak self] promise in
                guard let self else { return }
                self.container.performBackgroundTask { context in
                    do {
                        let req: NSFetchRequest<LikeDB> = LikeDB.fetchRequest()
                        req.fetchLimit = 1
                        req.predicate = NSPredicate(format: "id == %@", id)
                        if let mo = try context.fetch(req).first {
                            context.delete(mo)
                            try context.save()
                        }
                        promise(.success(()))
                    } catch {
                        promise(.failure(.custom(error.localizedDescription)))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - LikesDatasourceType -
extension LikesLocalDatasource: LikesDatasourceType {
    // Paging rule here: order by lastUpdated desc.
    // If "after id" provided: fetch items with lastUpdated < lastUpdated(of that id)
    func loadLikes(after id: String?, pageSize: Int) -> AnyPublisher<[LikeEntity], AppError> {
        Deferred {
            Future { [weak self] promise in
                guard let self else { return }
                
                self.container.performBackgroundTask { context in
                    do {
                        let cutoffLastUpdated: Int64? = try self.fetchLastUpdated(for: id, in: context)
                        
                        let req: NSFetchRequest<LikeDB> = LikeDB.fetchRequest()
                        req.sortDescriptors = [NSSortDescriptor(key: "lastUpdated", ascending: false)]
                        req.fetchLimit = pageSize
                        
                        if let cutoffLastUpdated {
                            req.predicate = NSPredicate(format: "lastUpdated < %lld", cutoffLastUpdated)
                        }
                        
                        let items = try context.fetch(req).map(LikeEntity.init(managedObject:))
                        promise(.success(items))
                    } catch {
                        promise(.failure(.custom(error.localizedDescription)))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func onDidLike(id: String, isSynced: Bool) -> AnyPublisher<(), AppError> {
        updateLike(id: id, isSynced: isSynced)
    }
    
    func onDidDiscard(id: String, isFail: Bool) -> AnyPublisher<(), AppError> {
        if isFail {
            return updateDiscard(id: id)
        } else {
            return delete(id: id)
        }
    }
    
    @MainActor
    func loadFailed() -> [LikeEntity] {
        let context = container.viewContext
        
        let req: NSFetchRequest<LikeDB> = LikeDB.fetchRequest()
        req.sortDescriptors = [NSSortDescriptor(key: "lastUpdated", ascending: false)]
        
        // (isDiscard == true AND isSynced == false) OR (isLiked == true AND isSynced == false)
        req.predicate = NSPredicate(format: "isSynced == NO AND (isDiscard == YES OR isLiked == YES)")
        
        let items = (try? context.fetch(req)) ?? []
        return items.map(LikeEntity.init(managedObject:))
    }
    
    
    func save(_ like: LikeEntity) {
        let context = container.viewContext
        context.performAndWait {
            do {
                let mo = try fetchOrCreate(id: like.id, in: context)
                mo.apply(like)
                try context.save()
            } catch {
                // up to you: log / assert / ignore
            }
        }
    }
}
