//
//  Transition+.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import UIKit

extension UIViewController {
    enum TransitionStyle {
        case presentNavigation
        case present
        case presentedViewDismiss
        case presentFullNavigation
        case push
        case dismiss
        case pop
        case popNavigations
        case alert
    }
    
    func transition<T: UIViewController>(_ viewController: T,
                                         _ style: TransitionStyle = .push,
                                         _ count: Int = 0,
                                         completion: ((T) -> Void)? = nil) {
        completion?(viewController)
        switch style {
        case .presentNavigation:
            let navigation = UINavigationController(rootViewController: viewController)
            viewController.modalPresentationStyle = .overFullScreen
            self.present(navigation, animated: true)
            
        case .present:
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
            
        case .presentedViewDismiss:
            self.dismiss(animated: true) {
                viewController.viewWillAppear(true)
            }
            
        case .presentFullNavigation:
            let navi = UINavigationController(rootViewController: viewController)
            navi.modalPresentationStyle = .fullScreen
            self.present(navi, animated: true)
            
        case .push:
            self.navigationController?.pushViewController(viewController, animated: true)
            
        case .dismiss:
            self.dismiss(animated: true)
            
        case .pop:
            navigationController?.popViewController(animated: true)
            
        case .popNavigations:
            let viewControllers = (self.navigationController?.viewControllers) as! [UIViewController]
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - count], animated: true)
            
        case .alert:
            viewController.modalPresentationStyle = .overCurrentContext
            self.present(viewController, animated: false)
        }
    }
}
