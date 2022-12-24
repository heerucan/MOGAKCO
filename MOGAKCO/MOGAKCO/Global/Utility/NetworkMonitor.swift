//
//  NetworkMonitor.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/13.
//

import UIKit
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    private(set) var isConnected = false
    private(set) var connectionType: ConnectionType = .unknown
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.isConnected = path.status == .satisfied
            self.getConenctionType(path)
            
            if self.isConnected {
//                print("연결된 상태임!")
            } else {
                print("연결 안된 상태임!")
            }
        }
    }
    
    func stopMonitoring() {
        print("stopMonitoring 호출")
        monitor.cancel()
    }
    
    private func getConenctionType(_ path:NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
            print("wifi에 연결")
            
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
            print("cellular에 연결")
            
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
            print("wiredEthernet에 연결")
            
        } else {
            connectionType = .unknown
            print("unknown")
        }
    }
}
