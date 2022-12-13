//
//  BaseViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import UIKit

class BaseViewController: UIViewController, BaseMethodProtocol {
    
    var keyboardHeight: CGFloat = 0
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        setupDelegate()
        setupNotificationCenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNotificationCenter()
        if NetworkMonitor.shared.isConnected {
            print("네트워크 연결")
        } else {
            print("네트워크 연결안됨")
            DispatchQueue.main.async {
                self.showAlert(title: "인터넷 연결이 끊겼습니다.",
                               message: "네트워크 연결상태를 확인해주세요.",
                               actions: [],
                               cancelTitle: "확인",
                               preferredStyle: .alert)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeNotificationCenter()
    }
    
    func configureUI() {
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
    }
    func configureLayout() { }
    func bindViewModel() { }
    func setupDelegate() { }
    
    func setupNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
    }
    
    func removeNotificationCenter() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
    }
        
    // MARK: - @objc
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
            as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.keyboardHeight = keyboardHeight
        }
    }
}
