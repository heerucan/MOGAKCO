//
//  Matrix.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import Foundation

enum Matrix {

    enum Auth {
        static let phoneTitle = "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요"
        static let messageTitle = "인증번호가 문자로 전송되었어요"
        static let nicknameTitle = "닉네임을 입력해 주세요"
        static let birthTitle = "생년월일을 알려주세요"
        static let emailTitle = "이메일을 입력해 주세요"
        static let genderTitle = "성별을 선택해 주세요"
        static let genderSubtitle = "새싹 찾기 기능을 이용하기 위해서 필요해요!"
        static let emailSubtitle = "휴대폰 번호 변경 시 인증을 위해 사용해요"
    }
    
    enum Button {
        static let phone = "인증 문자 받기"
        static let message = "인증하고 시작하기"
        static let next = "다음"
        static let start = "시작하기"
    }
    
    enum Placeholder {
        static let lineTextField = "내용을 입력"
        static let phone = "휴대폰 번호(-없이 숫자만 입력)"
        static let message = "인증번호 입력"
        static let nickname = "10자 이내로 입력"
        static let email = "SeSAC@email.com"
        static let chat = "메세지를 입력해보세요"
        static let review = "자세한 피드백은 다른 새싹들에게 도움이 됩니다\n(500자 이내 작성)"
    }
    
    enum Chat {
        static let matching = "님과 매칭되었습니다"
        static let description = "채팅을 통해 약속을 정해보세요 :)"
        static let maxHeight = 85.0
        static let defaultDate = "2000-01-01T00:00:00.000Z"
    }
    
    enum Shop {
        static let sesac = "새싹"
        static let background = "배경"
        static let width = 165
        static let height = 279
    }
    
    // MARK: - UserDefaults Key
    static let idToken = "idToken"
    static let verificationID = "authVerificationID"
    static let FCMtoken = "FCMtoken"
    
    // MARK: - 위도/경도
    static let ssacLat = 37.517819364682694
    static let ssacLong = 126.88647317074734
    static let settingMessage = "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요."
    static let markerSize = 83.0
}
