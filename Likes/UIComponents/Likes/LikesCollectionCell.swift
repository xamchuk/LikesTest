//
//  LikesCollectionCell.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 22.12.2025.
//


import UIKit

protocol LikesCollectionCellDelegate: AnyObject {
    func onLike(form cell: UICollectionViewCell)
    func onDiscard(from cell: UICollectionViewCell)
}

final class LikesCollectionCell: UICollectionViewCell {
    
    // MARK: - Views -
    private let mainImageView = UIImageView()
    private let photosCountView = UIView()
    private let photosCountIconView = UIImageView(image: .photosCount)
    private let photosCountLabel = LikesFactory.Labels.b2Medium(size: 10, color: .lWhite)
    
    private let likeButton = LikesFactory.Buttons.circle(image: .likeHeart,
                                                         backgroundColor: .lWhite,
                                                         size: 48)
    private let hideButton = LikesFactory.Buttons.circle(image: .xMark,
                                                         backgroundColor: .lBlack,
                                                         size: 48)
    
    private let sameGoalTag = LikeStatusTagView(backgroundColor: .lViolet, title: "Same goals")
    private let quickReplyTag = LikeStatusTagView(backgroundColor: .lBlue, title: "Quick to reply")
    private let nameLabel = LikesFactory.Labels.b2Bold(size: 14, color: .lWhite)
    private let fullFadeView = UIView()
    private let bottomFadeView = GradientView()
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    private var buttonsVStack = UIStackView()
    
    // MARK: - Delegate -
    private weak var delegate: LikesCollectionCellDelegate?
    
    // MARK: - Constants -
    private let bottomFadeViewHeight: CGFloat = 120
    
    // MARK: - Properties -
    private var indexPath = IndexPath(item: 0, section: 0)
  
    // MARK: - Init -
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        blurView.mask?.frame = .init(x: 0,
                                     y: 0,
                                     width: layoutAttributes.frame.width,
                                     height: bottomFadeViewHeight)
    }
    
    // MARK: - Setup -
    private func setup() {
        self.contentView.corner(24)
        self.contentView.clipsToBounds = true
        
        // mainImageView
        mainImageView.addAndFill(self.contentView)
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.backgroundColor(.lGrey.withAlphaComponent(0.13))
        
        // bottomFadeView
        self.contentView.addSubview(bottomFadeView)
        bottomFadeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomFadeView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            bottomFadeView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            bottomFadeView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            bottomFadeView.heightAnchor.constraint(equalToConstant: bottomFadeViewHeight)
        ])
      
      //  bottomFadeView.backgroundColor(.yellow)
        let g = bottomFadeView.gradientLayer
        g.colors = [UIColor.lGreyDark.cgColor, UIColor.clear.cgColor]
        g.startPoint = CGPoint(x: 0.5, y: 1.0)
        g.endPoint = CGPoint(x: 0.5, y: 0.0)
     
        blurView.addAndFill(bottomFadeView)
        let blurMask = GradientView()
        let mask = blurMask.gradientLayer
        mask.colors = [UIColor.clear.cgColor, UIColor.lGreyDark.cgColor]
        mask.startPoint = CGPoint(x: 0.5, y: 0.0)
        mask.endPoint   = CGPoint(x: 0.5, y: 1.0)
        blurView.mask = blurMask
       
        // nameLabel
        self.contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
            nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),
            nameLabel.heightAnchor.constraint(equalToConstant: 17)
        ])
        
        // photosCount
        photosCountView
            .backgroundColor(.lBlack.withAlphaComponent(0.64))
            .corner(8)
        
        self.contentView.addSubview(photosCountView)
        photosCountView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photosCountView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            photosCountView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
            ])

        // photosCountIconView
        photosCountView.addSubview(photosCountIconView)
        photosCountIconView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photosCountIconView.topAnchor.constraint(equalTo: photosCountView.topAnchor, constant: 4),
            photosCountIconView.leadingAnchor.constraint(equalTo: photosCountView.leadingAnchor, constant: 4),
            photosCountIconView.bottomAnchor.constraint(equalTo: photosCountView.bottomAnchor, constant: -4),
        ])
        
        // photosCountLabel
        photosCountLabel.textAlignment = .center
        photosCountView.addSubview(photosCountLabel)
        photosCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photosCountLabel.topAnchor.constraint(equalTo: photosCountView.topAnchor, constant: 4),
            photosCountLabel.trailingAnchor.constraint(equalTo: photosCountView.trailingAnchor, constant: -4),
            photosCountLabel.bottomAnchor.constraint(equalTo: photosCountView.bottomAnchor, constant: -4),
            photosCountLabel.leadingAnchor.constraint(equalTo: photosCountIconView.trailingAnchor),
            photosCountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 11)
        ])
        
        // likeButton, hideButton
        buttonsVStack = UIStackView(arrangedSubviews: [
            likeButton,
            hideButton
        ])
            .spacing(8)
            .axis(.vertical)
        
        self.contentView.addSubview(buttonsVStack)
        buttonsVStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonsVStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            buttonsVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
        
        likeButton.addTarget(self, action: #selector(onLikeTap), for: .touchUpInside)
        hideButton.addTarget(self, action: #selector(onDiscardTap), for: .touchUpInside)
        
        // sameGoalTag ,quickReplyTag
        let tagsVStack = UIStackView(arrangedSubviews: [
            sameGoalTag,
            quickReplyTag
        ]).axis(.vertical)
            .spacing(4)
            .alignment(.leading)
           
        self.contentView.addSubview(tagsVStack)
        tagsVStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagsVStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),
            tagsVStack.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -8)
        ])
    }
    
    // MARK: - Actions -
    @objc private func onLikeTap() {
        delegate?.onLike(form: self)
    }
    
    @objc private func onDiscardTap() {
        delegate?.onDiscard(from: self)
    }
    
    // MARK: - Public -
    func set(content: Content, delegate: LikesCollectionCellDelegate, indexPath: IndexPath, isLocked: Bool, isControls: Bool) {
        self.delegate = delegate
        self.indexPath = indexPath
        
        
        if isLocked {
            mainImageView.image = nil
        } else {
            mainImageView.setCachedImage(named: content.mainImage,
                                         placeholder: nil)
        }
        
        nameLabel.set(text: content.name, kernPx: 0)
        
        if content.photosCount > 0 {
            if photosCountView.isHidden {
                photosCountView.isHidden = false
            }
            photosCountLabel.set(text: "\(content.photosCount)", kernPx: 0)
        } else {
            if !photosCountView.isHidden {
                photosCountView.isHidden = true
            }
        }
        
        sameGoalTag.isHidden = !content.isSameGoal
        quickReplyTag.isHidden = !content.isQuickReply
        
        buttonsVStack.isHidden = !isControls
        
        self.layoutIfNeeded()
    }
}

// MARK: - Content -
extension LikesCollectionCell {
    struct Content: Identifiable, Hashable {
        let id: String
        let mainImage: String
        let photosCount: Int
        let isSameGoal: Bool
        let isQuickReply: Bool
        let name: String
    }
}
