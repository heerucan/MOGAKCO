//
//  APIManager.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import Foundation

import Alamofire

final class APIManager {
    private init() { }
    static let shared = APIManager()
    
    typealias Completions<T> = ((T?, Int?, APIError?) -> Void)
    
    func request<T: Decodable>(_ type: T.Type = T.self,
                               _ convertible: URLRequestConvertible,
                               completion: @escaping Completions<T>) {
        
        AF.request(convertible)
            .responseDecodable(of: type) { response in
                guard let statusCode = response.response?.statusCode else { return }
                completion(nil, statusCode, nil)
                print("🐹 상태코드만!!! ->>>\n" statusCode)
                switch response.result {
                case .success(let data):
                    completion(data, statusCode, nil)
                    print("🐹 성공!!! ->>>\n", data, statusCode)
                case .failure(_):
                    guard let error = APIError(rawValue: statusCode) else { return }
                    completion(nil, statusCode, error)
                    print("🐹 실패!!! ->>>\n", error, error.localizedDescription, statusCode)
                }
            }
    }
}
