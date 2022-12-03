//
//  ChatRouter.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/12/03.
//

import Foundation

import Alamofire

@frozen
enum ChatRouter {
    case sendChat(chat: String, to: String)
    case getChatList(from: String, lastchatDate: String)
}

extension ChatRouter: URLRequestConvertible {
    
    var baseURL: URL {
        return URL(string: APIKey.baseURL)!
    }
    
    var path: String {
        switch self {
        case .sendChat(_, let to):
            return "/v1/chat/\(to)"
        case .getChatList(let from, _):
            return "/v1/chat/\(from)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .sendChat: return .post
        case .getChatList: return .get
        }
    }
    
    var parameter: Parameters? {
        switch self {
        case .sendChat(let chat, _):
            return ["chat": chat]
        case .getChatList(_, let lastchatDate):
            return ["lastchatDate": lastchatDate]
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .sendChat: return URLEncoding.default
        case .getChatList: return URLEncoding.queryString
        }
    }
    
    var headers: HTTPHeaders {
        return ["idtoken": UserDefaultsHelper.standard.idToken ?? "",
                "Content-Type": APIKey.contentType]
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
