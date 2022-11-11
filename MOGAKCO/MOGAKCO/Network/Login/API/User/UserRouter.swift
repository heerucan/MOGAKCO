//
//  AuthRouter.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/11.
//

import Foundation

import Alamofire

enum AuthRouter {
    case login
    case signup
    case withdraw
    case updateFCMToken
}

extension AuthRouter: URLRequestConvertible {
    
    var baseURL: String {
        return APIKey.baseURL
    }
    
    var path: String {
        switch self {
        case .login:
            <#code#>
        case .signup:
            <#code#>
        case .withdraw:
            <#code#>
        case .updateFCMToken:
            <#code#>
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            <#code#>
        case .signup:
            <#code#>
        case .withdraw:
            <#code#>
        case .updateFCMToken:
            <#code#>
        }
    }
    
    var
    
    
    func asURLRequest() throws -> URLRequest {
        <#code#>
    }
    
    
}
