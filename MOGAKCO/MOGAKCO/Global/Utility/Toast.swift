//
//  Toast.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/12.
//

import Foundation

@frozen
enum Toast: String {
    case phoneTypeError
    case overRequestError
    case etcAuthError
    case phoneVerifyFail
    case nickTypeError
    case invalidNickname
    case birthTypeError
    case emailTypeError
    case overStudy
    case alreadyStudy
    case studyCount
    case currentUser
    case stopFind
    case studyRequestSuccess
    case stopFindStudy
    case acceptStudy
    
    var message: String {
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
        case .overStudy:
            return "스터디를 더 이상 추가할 수 없습니다"
        case .alreadyStudy:
                return "이미 등록된 스터디입니다"
        case .studyCount:
            return "최소 한 자 이상, 최대 8글자까지 작성 가능합니다"
        case .currentUser:
            return "이미 가입된 유저입니다."
        case .stopFind:
            return "누군가와 스터디를 함께하기로 약속하셨어요!"
        case .studyRequestSuccess:
            return "스터디 요청을 보냈습니다"
        case .stopFindStudy:
            return "상대방이 스터디 찾기를 그만두었습니다"
        case .acceptStudy:
            return "앗! 누군가가 나의 스터디를 수락하였어요"
        }
    }
}
