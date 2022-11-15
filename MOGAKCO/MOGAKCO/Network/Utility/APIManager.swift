//
//  APIManager.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import Foundation

import Alamofire
import FirebaseAuth

final class APIManager {
    private init() { }
    static let shared = APIManager()
    
    typealias Completion<T> = ((Result<T, APIError>) -> Void)
    typealias StatusCompletion<T> = ((Result<T, APIError>?, Int?) -> Void)
    
    func requestData<T: Decodable>(_ type: T.Type = T.self,
                                 _ convertible: URLRequestConvertible,
                                 completion: @escaping Completion<T>) {
        AF.request(convertible)
            .responseDecodable(of: type) { response in
                guard let statusCode = response.response?.statusCode else { return }
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                    
                case .failure(_):
                    guard let error = APIError(rawValue: statusCode) else { return }
                    completion(.failure(error))
                }
            }
    }

    func requestStatusData<T: Decodable>(type: T.Type = T.self,
                               method: HTTPMethod,
                               url: URL,
                               parameters: [String: Any]?,
                               headers: HTTPHeaders,
                               completion: @escaping StatusCompletion<T>) {
        AF.request(url, method: method, parameters: parameters, headers: headers)
            .responseDecodable(of: T.self) { response in
            guard let statusCode = response.response?.statusCode else { return }
            switch response.result {
            case .success(let data):
                completion(.success(data), statusCode)
                
            case .failure(_):
                guard let error = APIError(rawValue: statusCode) else { return }
                completion(.failure(error), statusCode)
            }
        }
    }
}
