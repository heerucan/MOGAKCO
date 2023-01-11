//
//  RealmChat.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/12/18.
//

import Foundation

import RealmSwift

final class RealmChat: Object {
    @Persisted var id: String
    @Persisted var from: String
    @Persisted var to: String
    @Persisted var chat: String
    @Persisted var createdAt: Date
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(id: String,
                     from: String,
                     to: String,
                     chat: String,
                     createdAt: Date) {
        self.init()
        self.id = id
        self.from = from
        self.to = to
        self.chat = chat
        self.createdAt = createdAt
    }
}
