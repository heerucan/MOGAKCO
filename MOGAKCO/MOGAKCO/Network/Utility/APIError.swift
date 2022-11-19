//
//  APIError.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import UIKit

import FirebaseAuth

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
            return "🔔 성공"
        case .nicknameError:
            return "🔔 사용불가 닉네임"
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

// MARK: - Error Handling

extension UIViewController {
        
    func handle(with error: APIError) {
        
        switch error {
        case .success:
            print(error.rawValue, error.errorDescription!)
            
        case .nicknameError:
            print(error.rawValue, error.errorDescription!)
            // TODO: - 리팩토링 시급한 부분
            let viewControllers: [UIViewController] = (self.navigationController?.viewControllers) as! [UIViewController]
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
            viewControllers[viewControllers.count - 4].showToast(ToastMatrix.invalidNickname.description)
            
        case .expiredTokenError:
            print(error.rawValue, error.errorDescription!)
            self.refreshToken()
            self.showToast(ToastMatrix.overRequestError.description)
            
        case .notCurrentUserError:
            print(error.rawValue, error.errorDescription!)
            let vc = NicknameViewController()
            self.transition(vc, .push)
            
        default:
            print(error.rawValue, error.errorDescription!)
        }
    }
    
    private func refreshToken() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                print("🔴Firebase idToken 실패 = 파베 기존 유저 아님", error.localizedDescription)
                return
            }
            guard let idToken = idToken else { return }
            print("🟢Firebase idToken 성공 ->>>", idToken)
            UserDefaultsHelper.standard.idToken = idToken
        }
    }
}
