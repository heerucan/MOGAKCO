//
//  RateRequest.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/12/03.
//

import Foundation

/**
 RateRequest : 리뷰 작성 요청 바디입니다.
 */

struct RateRequest: Codable {
    let otheruid: String
    let reputation: [Int]
    let comment: String
}
