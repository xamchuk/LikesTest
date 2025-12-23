//
//  SplashViewController.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 21.12.2025.
//

import UIKit

final class SplashViewController: BaseViewController {
    
    // MARK: - Views -
    private let spinner = UIActivityIndicatorView(style: .large)
    
    // MARK: - Properties -
    private let onDataLoaded: (Bool) -> Void
    
    // MARK: - Init -
    init(onDataLoaded: @escaping (Bool) -> Void) {
        self.onDataLoaded = onDataLoaded
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
        self.view.backgroundColor = .white
        
        let imageView = UIImageView(image: .splashMain)
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        
        spinner.color = .black
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -72)
        ])
        
        spinner.startAnimating()
    }
    
    // MARK: - Private -
    private func bind() {
        /// Can be Logic about:
        /// - loading data
        /// - Auth or getData
        /// - user id
        /// - Subscription
        /// - etc..
        ///  in particular this case - I'm imitating blurLikes flag
        ///
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) { [weak self] in
            guard let self = self else { return  }
            onDataLoaded(true)
            
            /// also i will put notification request here, but it's not good practice. If we had some login page or onboarding, ask after that flow.
            NotificationService.shared.requestAuthorisation()
        }
    }
}
