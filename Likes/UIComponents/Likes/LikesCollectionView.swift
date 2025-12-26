//
//  LikesCollectionView.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 22.12.2025.
//

import UIKit

protocol LikesCollectionViewDelegate: AnyObject {
    func willShowCell(id: String, of collectionView: UICollectionView)
    func didLike(id: String)
    func didDiscard(id: String)
}

final class LikesCollectionView: UICollectionView {
    
    private enum LikesSection: Hashable, Sendable { case main }
   
    // MARK: - Delegates -
    private weak var collectionDelegate: LikesCollectionViewDelegate?
    
    // MARK: - Properties -
    private var isLocked: Bool
    private let isCellButtons: Bool
  //  private var itemsById: [String: LikesCollectionCell.Content] = [:]
    private var dataSourceDiffable: UICollectionViewDiffableDataSource<LikesSection, LikesCollectionCell.Content>!
    
    // MARK: - Init -
    init(collectionDelegate: LikesCollectionViewDelegate, heightMultiplier: CGFloat, isLocked: Bool, isCellButtons: Bool) {
        self.isCellButtons = isCellButtons
        self.isLocked = isLocked
        self.collectionDelegate = collectionDelegate
        
        let layout = UICollectionViewCompositionalLayout { _, environment in
            return Self.makeSection(environment: environment,
                                    heightMultiplier: heightMultiplier)
        }
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.delegate = self
        
        self.backgroundColor = .clear
        self.clipsToBounds = true
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.register(LikesCollectionCell.self,
                      forCellWithReuseIdentifier: LikesCollectionCell.className)
        
        self.contentInset.top = 8
        self.contentInset.bottom = 65
        
        self.dataSourceDiffable = UICollectionViewDiffableDataSource<LikesSection, LikesCollectionCell.Content>(collectionView: self) { [weak self] collectionView, indexPath, content in
            guard let self else { return UICollectionViewCell() }
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LikesCollectionCell.className,
                for: indexPath
            ) as! LikesCollectionCell
            
         
                cell.set(content: content,
                         delegate: self,
                         indexPath: indexPath,
                         isLocked: self.isLocked,
                         isControls: self.isCellButtons)
            
            
            return cell
        }
        
        self.dataSource = dataSourceDiffable
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Data source -
    private func applySnapshot(likes: [LikesCollectionCell.Content], animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<LikesSection, LikesCollectionCell.Content>()
        snapshot.appendSections([.main])
        snapshot.appendItems(likes,
                             toSection: .main)
        dataSourceDiffable.apply(snapshot,
                                 animatingDifferences: animatingDifferences)
    }
    
    // MARK: - Layout -
    static private func makeSection(
        environment: NSCollectionLayoutEnvironment,
        headerHeight: CGFloat = 80,
        pinHeader: Bool = false,
        heightMultiplier: CGFloat = 1
    ) -> NSCollectionLayoutSection {
        
        let sideInset: CGFloat = 8
        let spacing: CGFloat = 8
        
        let containerWidth = environment.container.effectiveContentSize.width
        let itemSide = floor((containerWidth - (sideInset * 2) - spacing) / 2)
        
        // Item (square)
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemSide),
            heightDimension: .absolute(itemSide * heightMultiplier)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group (2 columns)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(containerWidth - (sideInset * 2)),
            heightDimension: .absolute(itemSide * heightMultiplier)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        group.interItemSpacing = .fixed(spacing)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: sideInset, bottom: 0, trailing: sideInset)
        section.interGroupSpacing = spacing
        
        return section
    }
    
    // MARK: - Public -
    func reloadAll(items: [LikesCollectionCell.Content]) {
        applySnapshot(likes: items, animatingDifferences: true)
    }
    
    func onLockedStateChange(isLocked: Bool) {
        if self.isLocked != isLocked {
            self.isLocked = isLocked
            
            var snapshot = dataSourceDiffable.snapshot()
            snapshot.reconfigureItems(snapshot.itemIdentifiers) 
            dataSourceDiffable.apply(snapshot, animatingDifferences: false)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout -
extension LikesCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let snapshot = dataSourceDiffable.snapshot()
        let total = snapshot.numberOfItems
        guard total > 0 else { return }
        
        if indexPath.item == total - 1, let lastItem = snapshot.itemIdentifiers.last {
            collectionDelegate?.willShowCell(id: lastItem.id, of: self)
        }
    }
}

// MARK: - LikesCollectionCellDelegate -
extension LikesCollectionView: LikesCollectionCellDelegate {
    func onLike(form cell: UICollectionViewCell) {
        guard let indexPath = indexPath(for: cell),
              let item = dataSourceDiffable.itemIdentifier(for: indexPath) else { return }
        collectionDelegate?.didLike(id: item.id)
    }
    
    func onDiscard(from cell: UICollectionViewCell) {
        guard let indexPath = indexPath(for: cell),
              let item = dataSourceDiffable.itemIdentifier(for: indexPath) else { return }
        collectionDelegate?.didDiscard(id: item.id)
    }
}
