//
//  UIViewController+.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import UIKit

extension UIViewController {
    func showAlert(title: String? = nil,
                   message: String? = nil,
                   actions: [UIAlertAction] = [],
                   cancelTitle: String? = "취소",
                   preferredStyle: UIAlertController.Style = .actionSheet) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: preferredStyle)
        let cancel = UIAlertAction(title: cancelTitle, style: .cancel)
        actions.forEach { alert.addAction($0) }
        alert.addAction(cancel)
        transition(alert, .present)
    }
    
    func showActivity(activityItems: [Any]) {
        let viewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        transition(viewController, .present)
    }
    
    var topViewController: UIViewController? {
        return self.topViewController(currentViewController: self)
    }
    
    func topViewController(currentViewController: UIViewController) -> UIViewController {
        if let tabBarController = currentViewController as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return self.topViewController(currentViewController: selectedViewController)
            
        } else if let navigationController = currentViewController as? UINavigationController,
                  let visibleViewController = navigationController.visibleViewController {
            return self.topViewController(currentViewController: visibleViewController)
            
        } else if let presentedViewController = currentViewController.presentedViewController {
            return self.topViewController(currentViewController: presentedViewController)
            
        } else {
            return currentViewController
        }
    }
}
