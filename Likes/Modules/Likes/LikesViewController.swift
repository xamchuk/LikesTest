//
//  LikesViewController.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 21.12.2025.
//

import UIKit
import Combine

final class LikesViewController: BaseViewController {
    
    // MARK: - Views -
    private let headerView = HeaderView(title: "Likes")
    private lazy var segmentControl = CustomSegmentedControlView { [weak self] index in
        self?.onSegmentChange(index: index)
    }
    private let scrollView = UIScrollView()
    private lazy var leftCollectionView = LikesCollectionView(collectionDelegate: self,
                                                              heightMultiplier: cellHeightMultiplier,
                                                              isLocked: false,
                                                              isCellButtons: true)
    private lazy var rightCollectionView = LikesCollectionView(collectionDelegate: self,
                                                               heightMultiplier: cellHeightMultiplier,
                                                               isLocked: false,
                                                               isCellButtons: false)
    
    
    // MARK: - UIConstants -
    private let cellHeightMultiplier: CGFloat = 1.4583
    
    // MARK: - Delegates -
    
    // MARK: - View Model -
    private let viewModel: LikesViewModelType
    
    // MARK: - Coordinator -
    private weak var coordinator: LikesCoordinatorProtocol?
    
    // MARK: - Properties -
    private var isLoading: Bool = false
    //lazy var timer = CountdownTimerService(delegate: self)
    
    // MARK: - Cancellable -
    private var cancellable = Set<AnyCancellable>()
    private var timerCancellable: AnyCancellable?
    
    // MARK: - Init -
    init(viewModel: LikesViewModelType, coordinator: LikesCoordinatorProtocol) {
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
        
        // segmentControl
        self.view.addSubview(segmentControl)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            segmentControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            segmentControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
        // scrollView
        self.view.addSubview(scrollView)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        scrollView.delegate = self
        
        // leftCollectionView
        scrollView.addSubview(leftCollectionView)
        leftCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftCollectionView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            leftCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            leftCollectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            leftCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            leftCollectionView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
      // rightCollectionView
        scrollView.addSubview(rightCollectionView)
        rightCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightCollectionView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            rightCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            rightCollectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            rightCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            rightCollectionView.leadingAnchor.constraint(equalTo: leftCollectionView.trailingAnchor)
        ])
    }
    
    // MARK: - Bind -
    private func bind() {
        viewModel.isLikesBlocked.sink { [weak self] isBlocked in
            if isBlocked {
                self?.leftCollectionView.isHidden = true
                self?.setLikesBlock()
            } else {
               
            }
        }.store(in: &cancellable)
        
        // MAKE first load of likes
        viewModel.onNextPage(id: nil)
            .receive(on: RunLoop.main)
            .sink { result in
            switch result {
                
            case .finished:
                break
            case .failure:
                // TODO: Handle errors
                break
            }
        } receiveValue: { }
            .store(in: &cancellable)

        // Observe changes
        viewModel.likedYouItems
            .receive(on: RunLoop.main)
            .sink { [weak self] likes in
                self?.leftCollectionView.reloadAll(items: likes)
        }.store(in: &cancellable)
        
        viewModel.likedSentItems
            .receive(on: RunLoop.main)
            .sink { [weak self] likes in
                self?.rightCollectionView.reloadAll(items: likes)
        }.store(in: &cancellable)
        
        // Sync failed items
        viewModel.syncFailed()
            .sink { _ in } receiveValue: { }
            .store(in: &cancellable)
        
        viewModel.subscribeLikes()
            .sink { _ in } receiveValue: {}
            .store(in: &cancellable)

    }
    
    // MARK: - Private -
    private func setLikesBlock() {
        let blockView = LikeBlockView(onUnblurTap: { [weak self] in
            self?.showTimerView()
        }, onGoToFinderTap: { [weak self] in
            self?.tabBarController?.selectedIndex = 0
        })
        blockView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(blockView)
        
        NSLayoutConstraint.activate([
            blockView.topAnchor.constraint(equalTo: leftCollectionView.topAnchor),
            blockView.leadingAnchor.constraint(equalTo: leftCollectionView.leadingAnchor),
            blockView.trailingAnchor.constraint(equalTo: leftCollectionView.trailingAnchor),
            blockView.bottomAnchor.constraint(equalTo: leftCollectionView.bottomAnchor)
        ])
    }
    
    
    private func onSegmentChange(index: Int) {
        if index == 1, scrollView.contentOffset.x != self.view.frame.width {
            scrollView.setContentOffset(.init(x: self.view.frame.width, y: 0), animated: true)
        } else if index == 0, scrollView.contentOffset.x != 0 {
            scrollView.setContentOffset(.zero, animated: true)
        }
    }
    
    private func showTimerView() {
        let timerView = TimerView()
        self.view.addSubview(timerView)
        timerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18),
            timerView.leadingAnchor.constraint(equalTo: leftCollectionView.leadingAnchor, constant: 16),
            timerView.trailingAnchor.constraint(equalTo: leftCollectionView.trailingAnchor, constant: -16),
        ])
        self.leftCollectionView.isHidden = false
        
        
        timerCancellable = viewModel.onUnblur().sink { [weak self, timerView] output in
            timerView.set(hours: output.hours,
                          minutes: output.minutes,
                          seconds: output.seconds)
            self?.leftCollectionView.onLockedStateChange(isLocked: output.secondLeft <= 0)
            if output.secondLeft == 0 {
                timerView.removeFromSuperview()
                self?.timerCancellable?.cancel()
                self?.viewModel.isLikesBlocked.send(true)
            }
        }
    }
}

// MARK: - UIScrollViewDelegate -
extension LikesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 {
            segmentControl.setActive(isLeft: true)
        } else if scrollView.contentOffset.x == self.view.frame.width {
            segmentControl.setActive(isLeft: false)
        }
    }
}

// MARK: - LikesCollectionViewDelegate -
extension LikesViewController: LikesCollectionViewDelegate {
    func didLike(id: String) {
        viewModel.onLike(id: id)
            .sink { _ in
            // If we save to database - we do not need error handling
            // but if not - on error - show popup
        } receiveValue: {  }
            .store(in: &cancellable)

    }
    
    func didDiscard(id: String) {
        viewModel.onDiscard(id: id)
            .sink { _ in
            // If we save to database - we do not need error handling
            // but if not - on error - show popup
        } receiveValue: { }
            .store(in: &cancellable)
    }
    
    func willShowCell(id: String, of collectionView: UICollectionView) {
        guard collectionView == leftCollectionView else { return }
        guard !isLoading else { return }
        
        isLoading = true
        viewModel.onNextPage(id: id)
            .sink { [weak self] result in
            switch result {
                
            case .finished:
                self?.isLoading = false
            case .failure:
                // TODO: Handle errors
                self?.isLoading = false
            }
        } receiveValue: { }
            .store(in: &cancellable)
    }
}
