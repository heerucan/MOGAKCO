//
//  ChatList.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/12/03.
//

import Foundation

/**
 ChatList : 채팅 목록 응답 모델입니다.
 */

struct ChatList: Codable {
    let payload: [Chat]
}

// MARK: - Chat
struct Chat: Codable {
    let id, to, from, chat: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case to, from, chat, createdAt
    }
}

