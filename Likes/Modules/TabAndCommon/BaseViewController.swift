//
//  BaseViewController.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 21.12.2025.
//

import UIKit

/// We can add default methods such as:
/// - loading view
/// - error popup
/// - keyboard closing on tap
/// - etc...
class BaseViewController: UIViewController {
  
    // MARK: - Views -
    
    // MARK: - Properties -
  
    // MARK: - Init -
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        gesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Setup Methods -
    
    // MARK: - Private -
    
    // MARK: - Actions -
    @objc private func closeKeyboard() {
        self.view.endEditing(true)
        self.view.subviews.forEach({
            $0.endEditing(true)
        })
    }
    
    // MARK: - Public -
   
}
