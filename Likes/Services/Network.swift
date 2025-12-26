//
//  NetworkRouter.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 22.12.2025.
//

import Foundation
import Combine

enum AppError: Error {
    case decodable
    case notInternet
    case custom(String)
    case request(Error)
    
    var message: String {
        switch self {
        case .decodable:
            return "Decodable error"
        case .notInternet:
            return "No internet connection"
        case .custom(let message):
            return message
        case .request(let error):
            return error.localizedDescription
        }
    }
}

// TODO: - It is just mock of simple network requests, I would make Router for network, example after 'extension NetworkService: Network'
protocol Network: AnyObject {
    func mockRequestGet(after id: String?, pageSize: Int) -> AnyPublisher<[LikeEntity], AppError>
    func mockLikeDidSet(for id: String) -> AnyPublisher<(), AppError>
    func mockDiscardDidSet(for id: String) -> AnyPublisher<(), AppError>
    func connect(url: URL, headers: [String: String]) -> AnyPublisher<LikeEntity, AppError>
}

final class NetworkService {
    
    // MARK: - Mock data -
    private static var mockData: [LikeEntity] = [
        
        .init(id: UUID().uuidString, name: "Omar", previewImageURL: "mock", images: ["1", "2", "3"], isSameGoal: false, isQuickReply: false, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Martin", previewImageURL: "mock1", images: ["1", "2", "3"], isSameGoal: false, isQuickReply: true, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Jaylon", previewImageURL: "mock2", images: ["1", "2", "3"], isSameGoal: false, isQuickReply: false, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Abram", previewImageURL: "mock3", images: ["1", "2", "3"], isSameGoal: false, isQuickReply: true, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Jakob", previewImageURL: "mock4", images: ["1", "2", "3"], isSameGoal: true, isQuickReply: false, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Tyler", previewImageURL: "mock5", images: ["1", "2", "3"], isSameGoal: true, isQuickReply: false, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Omar", previewImageURL: "mock", images: ["1", "2", "3"], isSameGoal: false, isQuickReply: false, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Martin", previewImageURL: "mock1", images: ["1", "2", "3"], isSameGoal: false, isQuickReply: true, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Jaylon", previewImageURL: "mock2", images: ["1", "2", "3"], isSameGoal: false, isQuickReply: false, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Abram", previewImageURL: "mock3", images: ["1", "2", "3"], isSameGoal: false, isQuickReply: true, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Jakob", previewImageURL: "mock4", images: ["1", "2", "3"], isSameGoal: true, isQuickReply: false, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Tyler", previewImageURL: "mock5", images: ["1", "2", "3"], isSameGoal: true, isQuickReply: false, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Omar", previewImageURL: "mock", images: ["1", "2", "3"], isSameGoal: false, isQuickReply: false, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Martin", previewImageURL: "mock1", images: ["1", "2", "3"], isSameGoal: false, isQuickReply: true, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Jaylon", previewImageURL: "mock2", images: ["1", "2", "3"], isSameGoal: false, isQuickReply: false, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Abram", previewImageURL: "mock3", images: ["1", "2", "3"], isSameGoal: false, isQuickReply: true, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Jakob", previewImageURL: "mock4", images: ["1", "2", "3"], isSameGoal: true, isQuickReply: false, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Tyler", previewImageURL: "mock5", images: ["1", "2", "3"], isSameGoal: true, isQuickReply: false, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Omar", previewImageURL: "mock", images: ["1", "2", "3"], isSameGoal: false, isQuickReply: false, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Martin", previewImageURL: "mock1", images: ["1", "2", "3"], isSameGoal: false, isQuickReply: true, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Jaylon", previewImageURL: "mock2", images: ["1", "2", "3"], isSameGoal: false, isQuickReply: false, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Abram", previewImageURL: "mock3", images: ["1", "2", "3"], isSameGoal: false, isQuickReply: true, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Jakob", previewImageURL: "mock4", images: ["1", "2", "3"], isSameGoal: true, isQuickReply: false, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Tyler", previewImageURL: "mock5", images: ["1", "2", "3"], isSameGoal: true, isQuickReply: false, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Omar", previewImageURL: "mock", images: ["1", "2", "3"], isSameGoal: false, isQuickReply: false, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Martin", previewImageURL: "mock1", images: ["1", "2", "3"], isSameGoal: false, isQuickReply: true, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Jaylon", previewImageURL: "mock2", images: ["1", "2", "3"], isSameGoal: false, isQuickReply: false, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Abram", previewImageURL: "mock3", images: ["1", "2", "3"], isSameGoal: false, isQuickReply: true, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Jakob", previewImageURL: "mock4", images: ["1", "2", "3"], isSameGoal: true, isQuickReply: false, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Tyler", previewImageURL: "mock5", images: ["1", "2", "3"], isSameGoal: true, isQuickReply: false, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Omar", previewImageURL: "mock", images: ["1", "2", "3"], isSameGoal: false, isQuickReply: false, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Martin", previewImageURL: "mock1", images: ["1", "2", "3"], isSameGoal: false, isQuickReply: true, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Jaylon", previewImageURL: "mock2", images: ["1", "2", "3"], isSameGoal: false, isQuickReply: false, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Abram", previewImageURL: "mock3", images: ["1", "2", "3"], isSameGoal: false, isQuickReply: true, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Jakob", previewImageURL: "mock4", images: ["1", "3"], isSameGoal: true, isQuickReply: false, lastUpdated: 0),
        .init(id: UUID().uuidString, name: "Tyler", previewImageURL: "mock5", images: ["1"], isSameGoal: true, isQuickReply: false, lastUpdated: 0),
    ]
    
    private let session: URLSession
    private var task: URLSessionWebSocketTask?
    private static let subject = PassthroughSubject<LikeEntity, AppError>()
    private let decoder: JSONDecoder
    
    // MARK: - Init -
    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }
    
    func connect(url: URL, headers: [String: String] = [:]) -> AnyPublisher<LikeEntity, AppError> {
        var request = URLRequest(url: url)
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        task = session.webSocketTask(with: request)
        task?.resume()
        
    //    receiveLoop()
        
        return Self.subject
            .print()
            .handleEvents(receiveCancel: { [weak self] in
                self?.disconnect()
            })
            .eraseToAnyPublisher()
    }
    
    func send(text: String) -> AnyPublisher<Void, AppError> {
        Future { [weak self] promise in
            guard let self, let task = self.task else {
                promise(.failure(.custom("Not connected")))
                return
            }
            
            task.send(.string(text)) { error in
                if let error {
                    promise(.failure(.request(error)))
                } else { promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func disconnect() {
        task?.cancel(with: .goingAway, reason: nil)
        task = nil
    }
    
    // MARK: - Private -
    private func receiveLoop() {
        guard let task else { return }
        
        task.receive { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let message):
                do {
                    let entity = try self.decode(message)
                    Self.subject.send(entity)
                } catch let appError as AppError {
                    Self.subject.send(completion: .failure(appError))
                    return
                } catch {
                    Self.subject.send(completion: .failure(.decodable)) // adjust
                    return
                }
                
                self.receiveLoop()
                
            case .failure(let error):
                Self.subject.send(completion: .failure(.custom(error.localizedDescription)))
            }
        }
    }
    
    private func decode(_ message: URLSessionWebSocketTask.Message) throws -> LikeEntity {
        let data: Data
        
        switch message {
        case .data(let d):
            data = d
        case .string(let text):
            guard let d = text.data(using: .utf8) else {
                throw AppError.decodable
            }
            data = d
        @unknown default:
            throw AppError.decodable
        }
        
        return try decoder.decode(LikeEntity.self, from: data)
    }
}

// MARK: - Simulate stream events
extension NetworkService {
    static func mockDeletion() {
        var firstItem = mockData[0]
        firstItem.isDiscard = true
        
        subject.send(firstItem)
    }
    
    static func mockInsertion() {
        let newItem: LikeEntity = .init(id: UUID().uuidString, name: "Ruslan", previewImageURL: "mock4", images: ["a"], isSameGoal: true, isQuickReply: true, lastUpdated: Int(Date().timeIntervalSince1970))
        mockData.insert(newItem, at: 0)
        subject.send(newItem)
    }
    
    static func mockUpdate() {
        var secondItem = mockData[1]
        secondItem.name = "Andrey"
        
        subject.send(secondItem)
    }
    
}

// MARK: - Network -
extension NetworkService: Network {
    
    func mockRequestGet(after id: String?, pageSize: Int) -> AnyPublisher<[LikeEntity], AppError> {
        
        let items: [LikeEntity]
        
        if let id,
           let index = NetworkService.mockData.firstIndex(where: { $0.id == id }) {
            // Start AFTER the given id
            let start = index + 1
            items = Array(NetworkService.mockData.dropFirst(start).prefix(pageSize))
        } else {
            // id == nil OR not found → start from beginning
            items = Array(NetworkService.mockData.prefix(pageSize))
        }
        
        return Just(items)
            .delay(for: .milliseconds(300), scheduler: RunLoop.main)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    func mockLikeDidSet(for id: String) -> AnyPublisher<(), AppError> {
        if let index = NetworkService.mockData.firstIndex(where: { $0.id == id }) {
            NetworkService.mockData[index].isLiked = true
            
            // Server will send push, but we don't have it , so just imitate
            NotificationService.shared.setOnNewLike(name: NetworkService.mockData[index].name)
            
            return Just(())
                .setFailureType(to: AppError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: AppError.custom("No like with id: \(id)")).eraseToAnyPublisher()
        }
    }
    
    func mockDiscardDidSet(for id: String) -> AnyPublisher<(), AppError> {
        if let index = NetworkService.mockData.firstIndex(where: { $0.id == id }) {
            NetworkService.mockData.remove(at: index)
            return Just(())
                .setFailureType(to: AppError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: AppError.custom("No like with id: \(id)")).eraseToAnyPublisher()
        }
    }
}

// My vision of Network
struct NetworkManager {
    
    func create<T>(request: NetworkRouter, type: T.Type) -> AnyPublisher<T, AppError> where T: Decodable {
        var urlRequest = URLRequest(url: URL(string: request.baseUrl + request.path)!)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.httpBody
        
        request.headers.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError { urlError -> AppError in
                switch urlError.code {
                case .notConnectedToInternet,
                        .dataNotAllowed,
                        .networkConnectionLost:
                    return .notInternet
                default:
                    return .request(urlError)
                }
            }
            .map(\.data)
            .handleEvents(receiveOutput: { data in
                let string = String(data: data, encoding: .utf8)
                print(string ?? "")
            })
            .map({
                return $0
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> AppError in
                if let _ = error as? DecodingError {
                    /// Better to catch decoding error in development
                    assertionFailure("\(error)")
                    return .decodable
                }
                if let apiError = error as? AppError {
                    return apiError
                }
                return .custom(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    
}

enum NetworkRouter {
    
    enum Method: String {
        case get = "GET"
        case post = "POST"
    }
    
    // Import, Export Database
    case getLikes(lastId: String?, pageSize: Int, boundary: String)
    
    
    var baseUrl: String {
        switch self {
        case .getLikes:
            "https://someServerURL.com"
        }
    }
    
    var path: String {
        
        switch self {
            
        case .getLikes:
            return "/likes-get"
            
        }
    }
    
    var boundary: String {
        switch self {
        case .getLikes(_, _, let boundary):
            return boundary
        }
    }
    
    var httpBody: Data? {
        switch self {
        case .getLikes(let lastId, let pageSize, let boundary):
            // parameters or json body
            return nil
        }
    }
    
    var method: Method {
        switch self {
        case .getLikes:
            return .get
        }
    }
    
    var headers: [String: String] {
        switch self {
            
        case .getLikes:
            return ["Session-Token": "some user's token",
                    "Content-Type": "application/json"]
        }
    }
}
