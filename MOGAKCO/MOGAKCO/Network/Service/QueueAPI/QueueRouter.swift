//
//  QueueRouter.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/18.
//

import Foundation

import Alamofire

@frozen
enum QueueRouter {
    case findQueue(_ findQueue: FindRequest)
    case stopQueue
    case search(_ searchQueue: SearchRequest)
    case myQueueState
    case studyRequest(_ otheruid: String)
    case studyAccept(_ otheruid: String)
    case dodge(_ otheruid: String)
    case rate(_ uid: String, rate: RateRequest)
}

extension QueueRouter: URLRequestConvertible {
    
    var baseURL: URL {
        return URL(string: APIKey.baseURL)!
    }
    
    var path: String {
        switch self {
        case .findQueue, .stopQueue: return "/v1/queue"
        case .search: return "/v1/queue/search"
        case .myQueueState: return "/v1/queue/myQueueState"
        case .studyRequest: return "/v1/queue/studyrequest"
        case .studyAccept: return "/v1/queue/studyaccept"
        case .dodge: return "/v1/queue/dodge"
        case .rate(let uid,_): return "/v1/queue/rate/\(uid)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .findQueue, .search, .studyRequest, .studyAccept, .dodge, .rate:
            return .post
        case .stopQueue:
            return .delete
        case .myQueueState:
            return .get
        }
    }
    
    var parameter: Parameters? {
        switch self {
        case .findQueue(let findQueue):
            return ["long": findQueue.long,
                    "lat": findQueue.lat,
                    "studylist": findQueue.studylist]
        case .search(let searchQueue):
            return ["lat": "\(searchQueue.lat)",
                    "long": "\(searchQueue.long)"]
        case .studyRequest(let otheruid), .studyAccept(let otheruid), .dodge(let otheruid):
            return ["otheruid": otheruid]
        case .rate(_, let rate):
            return ["otheruid": rate.otheruid,
                    "reputation": rate.reputation,
                    "comment": rate.comment]
        default: return nil
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .findQueue:
            return URLEncoding(arrayEncoding: .noBrackets)
        case .myQueueState:
            return JSONEncoding.default
        default: return URLEncoding.default
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
