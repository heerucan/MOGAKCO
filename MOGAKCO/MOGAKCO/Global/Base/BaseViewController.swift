//
//  BaseViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import UIKit

import Network

class BaseViewController: UIViewController, BaseMethodProtocol {
    
    // MARK: - Property
    
    private let monitor = NWPathMonitor()
    let wifimonitor = NWPathMonitor(requiredInterfaceType: .wifi)
    
    private var keyboardHeight: CGFloat = 0
    
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
        navigationController?.isNavigationBarHidden = true
    }
    func configureLayout() { }
    func bindViewModel() { }
    func setupDelegate() { }
    
    // MARK: - Check Network Status
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            if path.status == .satisfied {
                print("네트워크 - 연결상태좋음")
                if path.usesInterfaceType(.cellular) {
                    print("네트워크 - 셀룰러")
                } else if path.usesInterfaceType(.wifi) {
                    print("네트워크 - 와이파이")
                } else if path.usesInterfaceType(.wiredEthernet) {
                    print("네트워크 - 유선연결")
                } else {
                    print("네트워크 - 기타")
                }
            } else {
                print("네트워크 - 연결끊김")
                DispatchQueue.main.async {
//                    let alert = UIAlertController(title: "인터넷 연결이 끊겼습니다.",
//                                                  message: "네트워크 연결상태를 확인해주세요.",
//                                                  preferredStyle: .alert)
//                    let cancel = UIAlertAction(title: "확인", style: .cancel)
//                    alert.addAction(cancel)
//                    self.transition(alert, .present)
                    self.showToast("네트워크 연결상태를 확인해주세요.")
                }
            }
        }
        monitor.start(queue: .global())

    }
    
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
