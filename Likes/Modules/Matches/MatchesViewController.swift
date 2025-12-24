//
//  MatchesViewController.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 21.12.2025.
//

import UIKit
import Combine

final class MatchesViewController: BaseViewController {
    
    // MARK: - Views -
    private let headerView = HeaderView(title: "Mutuals")
   
    private lazy var collectionView = LikesCollectionView(collectionDelegate: self,
                                                              heightMultiplier: cellHeightMultiplier,
                                                              isLocked: false,
                                                              isCellButtons: false)
    
    
    
    // MARK: - UIConstants -
    private let cellHeightMultiplier: CGFloat = 1.4583
    
    // MARK: - Delegates -
    
    // MARK: - View Model -
    private let viewModel: MatchesViewModelType
    
    // MARK: - Coordinator -
    private weak var coordinator: MatchesCoordinatorProtocol?
    
    // MARK: - Properties -
 
    // MARK: - Cancellable -
    private var cancellable = Set<AnyCancellable>()
   
    
    // MARK: - Init -
    init(viewModel: MatchesViewModelType, coordinator: MatchesCoordinatorProtocol) {
        self.viewModel = viewModel
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
        bind()
    }
    
    // MARK: - Setup Methods -
    private func setup() {
        self.view.backgroundColor = .lWhite
        
        // headerView
        self.view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
        // collectionView
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    // MARK: - Bind -
    private func bind() {
        // Observe changes
        viewModel.likedSentItems
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] likes in
                self?.collectionView.reloadAll(items: likes)
        }.store(in: &cancellable)
    }
}

// MARK: - UIScrollViewDelegate -

// MARK: - LikesCollectionViewDelegate -
extension MatchesViewController: LikesCollectionViewDelegate {
    func willShowCell(id: String, of collectionView: UICollectionView) {}
    
    func didLike(id: String) {}
    
    func didDiscard(id: String) { }
}
