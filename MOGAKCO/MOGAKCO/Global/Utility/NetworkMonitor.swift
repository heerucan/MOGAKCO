//
//  NetworkMonitor.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/13.
//

import UIKit
import Network

final class NetworkMonitor: UIViewController {
    
    let networkMonitor = NWPathMonitor()
    let wifiMonitor = NWPathMonitor(requiredInterfaceType: .wifi)
    let monitor = NWPathMonitor(prohibitedInterfaceTypes: [.wifi, .cellular])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkNetworkStatus()
    }
    
    func checkNetworkStatus() {
        self.networkMonitor.start(queue: DispatchQueue.global())

        networkMonitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            if path.status == .satisfied {
                print("네트워크 연결 상태 좋음")
                if path.usesInterfaceType(.cellular) {
                    print("셀룰러")
                } else if path.usesInterfaceType(.wifi) {
                    print("와이파이")
                } else if path.usesInterfaceType(.wiredEthernet) {
                    print("유선연결")
                } else {
                    print("기타")
                }
            } else {
                print("네트워크 연결 끊김")
//                DispatchQueue.main.async {
//                    let alert = UIAlertController(title: "인터넷 연결이 끊겼습니다.",
//                                                  message: "네트워크 연결상태를 확인해주세요.",
//                                                  preferredStyle: .alert)
//                    let cancel = UIAlertAction(title: "확인", style: .cancel)
//                    alert.addAction(cancel)
//                    self.transition(alert, .present)
//                }
            }
        }
    }
}
