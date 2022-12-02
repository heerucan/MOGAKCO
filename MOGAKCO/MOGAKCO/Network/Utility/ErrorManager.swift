//
//  ErrorManager.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import UIKit

import FirebaseAuth

final class ErrorManager {
    private init() { }
    
    static func refreshToken(completion: @escaping (() -> Void)) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                print("🔴Firebase idToken 실패 = 파베 기존 유저 아님", error.localizedDescription)
                return
            }
            guard let idToken = idToken else { return }
            print("🟢Firebase idToken 성공 ->>>", idToken)
            UserDefaultsHelper.standard.idToken = idToken
            completion()
        }
    }
    
    static func handle(with error: APIError, vc: UIViewController) {
        switch error {
        case .expiredToken:
            vc.showToast(APIError.expiredToken.message)
            
        case .notCurrentUser:
            vc.showToast(APIError.notCurrentUser.message)
            let nicknameVC = NicknameViewController()
            vc.transition(nicknameVC, .push)
            
        default: break
        }
    }
}

enum APIError: Int, Error, CaseIterable {
    case expiredToken = 401
    case notCurrentUser = 406
    case server = 500
    case client = 501
    
    var message: String {
        switch self {
        case .expiredToken:
            return "과도한 인증 시도가 있었습니다. 나중에 다시 시도해 주세요."
        case .notCurrentUser:
            return "새싹 스터디 서버에 최종 가입이 되지 않은 미가입 유저"
        case .server:
            return "Server Error"
        case .client:
            return "API 요청시 Header와 RequestBody에 값을 빠트리지 않고 전송했는지 확인"
        }
    }
}
