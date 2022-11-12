//
//  ToastMatrix.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/12.
//

import Foundation

@frozen
enum ToastMatrix: String {
    case phoneTypeError
    case overRequestError
    case etcAuthError
    case phoneVerifyFail
    case nickTypeError
    case invalidNickname
    case birthTypeError
    case emailTypeError
    
    var description: String {
        switch self {
        case .phoneTypeError:
            return "잘못된 전화번호 형식입니다."
        case .overRequestError:
            return "과도한 인증 시도가 있었습니다. 나중에 다시 시도해 주세요."
        case .etcAuthError:
            return "에러가 발생했습니다. 다시 시도해주세요"
        case .phoneVerifyFail:
            return "전화 번호 인증 실패"
        case .nickTypeError:
            return "닉네임은 1자 이상 10자 이내로 부탁드려요."
        case .invalidNickname:
            return "해당 닉네임은 사용할 수 없습니다."
        case .birthTypeError:
            return "새싹스터디는 만 17세 이상만 사용할 수 있습니다."
        case .emailTypeError:
            return "이메일 형식이 올바르지 않습니다."
        }
    }
}
