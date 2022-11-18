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
    
    func showToast(_ message: String) {
        let toastLabel = UILabel(frame: CGRect(x: UIScreen.main.bounds.size.width/2-(UIScreen.main.bounds.size.width-32)/2,
                                               y: 100,
                                               width: UIScreen.main.bounds.size.width-32,
                                               height: 40)).then {
            $0.backgroundColor = Color.black.withAlphaComponent(0.89)
            $0.textColor = .white
            $0.font = Font.body4.font
            $0.textAlignment = .center
            $0.text = message
            $0.layer.cornerRadius = 10
            $0.clipsToBounds  =  true
            view.addSubview($0)
        }
        
        UIView.animate(withDuration: 2, delay: 0.2, options: .curveEaseIn) {
            toastLabel.alpha = 0.0
        } completion: { _ in
            toastLabel.removeFromSuperview()
        }
    }
}
