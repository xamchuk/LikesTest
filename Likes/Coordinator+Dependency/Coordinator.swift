//
//  Coordinator.swift
//  Likes
//
//  Created by Ruslan Khamskyi on 21.12.2025.
//


import UIKit

protocol Coordinator: AnyObject {
    
    var presenter: UINavigationController { get }
    
    func start()
    func dismiss()
    func pop()
    func popToRoot()
}

extension Coordinator {
    func dismiss() {
        presenter.presentedViewController?.dismiss(animated: true)
    }
    
    func pop() {
        presenter.popViewController(animated: true)
    }
    
    func popToRoot() {
        
        presenter.dismiss(animated: true)
        presenter.popToRootViewController(animated: true)
    }
}
