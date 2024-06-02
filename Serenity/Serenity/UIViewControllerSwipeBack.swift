//
//  UIViewControllerSwipeBack.swift
//  Serenity
//
//  Created by 이하은 on 6/1/24.
//

import UIKit

extension UIViewController {
    func setupSwipeBackGesture() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeBack))
        swipeGesture.direction = .right
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc private func handleSwipeBack() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
