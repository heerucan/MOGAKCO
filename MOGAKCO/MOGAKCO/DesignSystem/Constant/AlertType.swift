//
//  AlertType.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/23.
//

import UIKit

// MARK: - Enum

@frozen
enum AlertType {
    case withdraw
    case studyRequest
    case studyAccept
    case studyCancel
    case addFriend
    
    var title: String {
        switch self {
        case .withdraw:
            return "정말 탈퇴하시겠습니까?"
        case .studyRequest:
            return "스터디를 요청할게요!"
        case .studyAccept:
            return "스터디를 수락할까요?"
        case .studyCancel:
            return "스터디를 취소하겠습니까?"
        case .addFriend:
            return "고래밥님을 친구 목록에 추가할까요?"
        }
    }
    
    var subtitle: String {
        switch self {
        case .withdraw:
            return "탈퇴하시면 새싹 스터디를 이용할 수 없어요ㅠ"
        case .studyRequest:
            return "요청이 수락되면 30분 후에 리뷰를 남길 수 있어요"
        case .studyAccept:
            return "요청을 수락하면 채팅창에서 대화를 나눌 수 있어요"
        case .studyCancel:
            return "스터디를 취소하시면 패널티가 부과됩니다"
        case .addFriend:
            return "친구 목록에 추가하면 언제든지 채팅을 할 수 있어요"
        }
    }
}
