//
//  RealmRepository.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/12/18.
//

import Foundation

import RealmSwift

final class RealmRepository {
    private init() { }
    static let shared = RealmRepository()
    
    let localRelam = try! Realm()
    
    // [Payload]로 반환해주면 된다. 렘테스크로 보여줄 필요가 없다.
    func fetchChatData(matchedId: String) -> [Chat] {
        
        let data = localRelam.objects(RealmChat.self)
            .sorted(byKeyPath: "createdAt", ascending: true)
            .filter("id CONTAINS '"+matchedId+"'")
        
        var id = ""
        var to = ""
        var from = ""
        var createdAt = Date()
        var chat = ""
        
        data.forEach {
            id = $0.id
            to = $0.to
            from = $0.from
            createdAt = $0.createdAt
            chat = $0.chat
        }
        return [Chat(id: id, to: to, from: from, chat: chat, createdAt: "\(createdAt)")]
    }
    
    func getLastDate() -> String? {
        let tasks = localRelam.objects(RealmChat.self).sorted(byKeyPath: "createdAt", ascending: false)
        return tasks.first?.createdAt.toString()
    }
    
    func addChatData(chat: RealmChat) {
        try! localRelam.write {
            localRelam.add(chat)
        }
    }
    
    func addChatDataList(chatlist: [RealmChat]) {
        try! localRelam.write {
            localRelam.add(chatlist)
        }
    }
}
