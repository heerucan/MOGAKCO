//
//  UserRouter.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/11.
//

import Foundation

import Alamofire

enum UserRouter {
    case login
//    case signup(phone: String, name: String, birth: String, fcm: String, email: String, gender: Int)
    case signup(signup: SignupRequest)
    case withdraw
    case updateFCMToken
}

extension UserRouter: URLRequestConvertible {
    
    var baseURL: URL {
        return URL(string: APIKey.baseURL)!
    }
    
    var path: String {
        switch self {
        case .login, .signup: return "/v1/user"
        case .withdraw: return "/v1/user/withdraw"
        case .updateFCMToken: return "/v1/user/update_fcm_token"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login: return .get
        case .signup: return .post
        case .withdraw: return .post
        case .updateFCMToken: return .put
        }
    }
    
    var headers: HTTPHeaders {
        return ["idtoken": UserDefaultsHelper.standard.idToken ?? "",
                "Content-Type": APIKey.applicationJSON]
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers
        return request
    }
}
