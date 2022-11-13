//
//  APIError.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import Foundation

@frozen
enum APIError: Int, Error {
    case success = 200
    case nicknameError = 202
    case expiredTokenError = 401
    case notCurrentUserError = 406
    case serverError = 500
    case clientError = 501
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .success:
            return "성공"
        case .nicknameError:
            return "사용불가닉네임"
        case .expiredTokenError:
            return "과도한 인증 시도가 있었습니다. 나중에 다시 시도해 주세요."
        case .notCurrentUserError:
            return "🔔 새싹 스터디 서버에 최종 가입이 되지 않은 미가입 유저"
        case .serverError:
            return "🔔 Server Error"
        case .clientError:
            return "🔔 API 요청시 Header와 RequestBody에 값을 빠트리지 않고 전송했는지 확인"
        }
    }
}
