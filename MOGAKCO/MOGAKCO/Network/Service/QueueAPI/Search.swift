//
//  SearchResponse.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/18.
//

import Foundation

/**
 Search : 주변 새싹 탐색을 위한 Queue Response 모델입니다.
 */

struct Search: Codable, Hashable {
    let fromQueueDB, fromQueueDBRequested: [FromQueueDB]
    let fromRecommend: [String]
}

// MARK: - FromQueueDB

struct FromQueueDB: Codable, Hashable {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let studylist, reviews: [String]
    let gender, type, sesac, background: Int
}
