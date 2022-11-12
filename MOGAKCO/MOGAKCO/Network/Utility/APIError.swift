//
//  APIError.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import Foundation

@frozen
enum APIError: Int, Error {
    case expiredTokenError = 401
    case notCurrentUserError = 406
    case serverError = 500
    case clientError = 501
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .expiredTokenError:
            return "🔔 401: Firebase Token 만료"
        case .notCurrentUserError:
            return "🔔 406: 새싹 스터디 서버에 최종 가입이 되지 않은 미가입 유저"
        case .serverError:
            return "🔔 500: Server Error"
        case .clientError:
            return "🔔 501: API 요청시 Header와 RequestBody에 값을 빠트리지 않고 전송했는지 확인"
        }
    }
}
