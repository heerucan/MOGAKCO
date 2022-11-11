//
//  SSACAPIManager.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import Foundation

import Alamofire

final class SSACAPIManager {
    private init() { }
    static let shared = SSACAPIManager()
    
    typealias Completion<T> = ((Result<T, APIError>) -> Void)
    
    func requestData<T: Decodable>(_ type: T.Type = T.self,
                                 _ convertible: URLRequestConvertible,
                                 completion: @escaping Completion<T>) {
        AF.request(convertible)
            .responseDecodable(of: T.self) { response in
                guard let statusCode = response.response?.statusCode else { return }
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                    
                case .failure(_):
                    guard let error = APIError(rawValue: statusCode) else { return }
                    completion(.failure(error))
                    print(error.localizedDescription)
                }
            }
    }
}
