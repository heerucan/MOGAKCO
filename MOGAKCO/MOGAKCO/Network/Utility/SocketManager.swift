//
//  SocketManager.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/12/03.
//

import Foundation

import SocketIO

class SocketIOManager {
    static let shared = SocketIOManager()
    
    // 서버와 메시지를 주고 받기 위한 클래스
    var manager: SocketManager!
    var socket: SocketIOClient!
    
    private init() {
        manager = SocketManager(
            socketURL: URL(string: APIKey.baseURL)!,
            config: [
                .log(true),
                .forceWebsockets(true)
            ]
        )

        socket = manager.defaultSocket // 이걸루 기본 서버 링크로 소통할 것임
        
        // 연결
        socket.on(clientEvent: .connect) { data, ack in
            print("💡 SOCKET IS CONNECTED", data, ack)
            guard let myuid = UserDefaultsHelper.standard.myuid else { return }
            self.socket.emit("changesocketid", myuid)
        }
        
        // 연결 해제
        socket.on(clientEvent: .disconnect) { data, ack in
            print("💡 SOCKET IS DISCONNECTED", data, ack)
        }
        
        // 이벤트 수신
        socket.on("chat") { dataArray, ack in
            print("💡 CHAT RECEIVED", dataArray, ack)
            
            let data = dataArray[0] as! NSDictionary
            let id = data["_id"] as! String
            let chat = data["text"] as! String
            let createdAt = data["createdAt"] as! String
            let from = data["from"] as! String
            let to = data["to"] as! String

            print("💡 Check >>>>", chat, createdAt, from, to)
            
            NotificationCenter.default.post(name: NSNotification.getMessage,
                                            object: self,
                                            userInfo: ["id" : id,
                                                       "chat" : chat,
                                                       "createdAt" : createdAt,
                                                       "from" : from,
                                                       "to" : to])
        }
    }
    
    // 실질적으로 connect, disconnect 해주는 메소드
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}
