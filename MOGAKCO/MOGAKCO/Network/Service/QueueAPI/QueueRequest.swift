//
//  QueueRequest.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/18.
//

import Foundation

/**
 QueueRequst : 내 주변 새싹 찾기 요청 바디입니다.
 */

struct FindRequest: Codable {
    let long: Double
    let lat: Double
    let studylist: [String]
}

struct SearchRequest: Codable {
    let lat: Double
    let long: Double
}
