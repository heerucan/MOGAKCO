//
//  BaseViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import UIKit

class BaseViewController: UIViewController, BaseMethodProtocol {
    
    // MARK: - Property
    
    var keyboardHeight: CGFloat = 0
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        setupDelegate()
        setupNotificationCenter()
    }
    
    func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = " "
    }
    func configureLayout() { }
    func bindViewModel() { }
    func setupDelegate() { }
    
    // MARK: - Keyboard
    
    func setupNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
    }
    
    // MARK: - @objc
    
    @objc func keyboardWillShow(_ notification:NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.keyboardHeight = keyboardHeight
        }
    }
}
