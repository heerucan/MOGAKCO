//
//  QueueState.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/19.
//

import Foundation

/**
 QueueState : 사용자 본인의 상태 확인하는 Response Model
 */

struct QueueState: Codable {
    let dodged, matched, reviewed: Int
    let matchedNick, matchedUid: String?
}
