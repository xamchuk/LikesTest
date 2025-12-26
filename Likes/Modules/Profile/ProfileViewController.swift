//
//  ProfileViewController.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 21.12.2025.
//

import UIKit

final class ProfileViewController: BaseViewController {
    
    // MARK: - Coordinator -
    private weak var coordinator: ProfileCoordinatorProtocol?
 
    // MARK: - Init -
    init(coordinator: ProfileCoordinatorProtocol) {
        self.coordinator = coordinator
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup Methods -
    private func setup() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            NetworkService.mockDeletion()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                NetworkService.mockUpdate()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    NetworkService.mockInsertion()
                }
            }
        }
    }
}
