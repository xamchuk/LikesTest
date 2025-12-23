//
//  MessagesViewController.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 21.12.2025.
//

import UIKit

final class MessagesViewController: BaseViewController {
    
    // MARK: - Views -
    
    // MARK: - Constraints -
    
    // MARK: - UIConstants -
    
    // MARK: - Delegates -
    
    // MARK: - View Model -
    
    // MARK: - Coordinator -
    private weak var coordinator: MessagesCoordinatorProtocol?
    
    // MARK: - Properties -
    
    // MARK: - Init -
    init(coordinator: MessagesCoordinatorProtocol) {
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
        
    }
    
    // MARK: - Private -
    
    // MARK: - Actions -

}
