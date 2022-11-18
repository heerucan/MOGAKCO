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
    let matchedNick, matchedUid: String
    
    enum CodingKyes: String, CodingKey {
        case dodged, matched, reviewed
        case matchedNick, matchedUid
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dodged = try container.decode(Int.self, forKey: .dodged)
        matched = try container.decode(Int.self, forKey: .matched)
        reviewed = try container.decode(Int.self, forKey: .reviewed)
        matchedNick = try container.decodeIfPresent(String.self, forKey: .matchedNick) ?? ""
        matchedUid = try container.decodeIfPresent(String.self, forKey: .matchedUid) ?? ""
    }
}
