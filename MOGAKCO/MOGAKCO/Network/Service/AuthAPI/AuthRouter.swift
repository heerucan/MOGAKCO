//
//  AuthRouter.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/11.
//

import Foundation

import Alamofire

@frozen
enum AuthRouter {
    case login
    case signup(_ signup: SignupRequest)
    case withdraw
    case updateFCMToken
}

extension AuthRouter: URLRequestConvertible {
    
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
    
    var parameter: Parameters? {
        switch self {
        case .signup(let signup):
            return ["phoneNumber": signup.phoneNumber,
                    "FCMtoken": signup.FCMtoken,
                    "nick": signup.nick,
                    "birth": signup.birth,
                    "email": signup.email,
                    "gender": "\(signup.gender)"]
        default: return nil
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .signup:
            return JSONEncoding.default
        default: return JSONEncoding.default
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
        if let parameter = parameter {
            return try encoding.encode(request, with: parameter)
        }
        return request
    }
}
