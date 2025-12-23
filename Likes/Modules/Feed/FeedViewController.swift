//
//  FeedViewController.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 21.12.2025.
//

import UIKit

final class FeedViewController: BaseViewController {
    
    // MARK: - Views -
    
    // MARK: - Constraints -
    
    // MARK: - UIConstants -
    
    // MARK: - Delegates -
    
    // MARK: - View Model -
    
    // MARK: - Coordinator -
    private weak var coordinator: FeedCoordinatorProtocol?
    
    // MARK: - Properties -
    
    // MARK: - Init -
    init(coordinator: FeedCoordinatorProtocol) {
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
