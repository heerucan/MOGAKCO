//
//  APIManager.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import Foundation

import Alamofire
import RxSwift

final class APIManager {
    private init() { }
    static let shared = APIManager()
    
    typealias Completions<T> = ((T?, Int?, APIError?) -> Void)
    
    func request<T: Decodable>(_ type: T.Type = T.self,
                               _ convertible: URLRequestConvertible,
                               completion: @escaping Completions<T>) {
        
        AF.request(convertible)
            .responseDecodable(of: type) { [weak self] response in
                guard let self = self else { return }
                guard let statusCode = response.response?.statusCode else { return }
                completion(nil, statusCode, nil)
                print("⚠️ 상태코드만!!! ->>>", statusCode)
                
                switch response.result {
                case .success(let data):
                    completion(data, statusCode, nil)
                    print("✅ 성공!!! ->>>", data, statusCode)
                    
                case .failure(_):
                    guard let error = APIError(rawValue: statusCode) else { return }
                    if error.rawValue == 401 {
                        ErrorManager.refreshToken {
                            self.request(type, convertible, completion: completion)
                        }
                    }
                    completion(nil, statusCode, error)
                    print("❌ 실패!!! ->>>", error, error.localizedDescription, statusCode)
                }
            }
    }
    
    func fetch<T: Codable>(_ type: T.Type = T.self,
                           _ convertible: URLRequestConvertible) -> Observable<(T?, Int, APIError?)> {
        
        return Observable.create { emitter -> Disposable in
            let dataRequest = AF.request(convertible).responseData { response in
                guard let statusCode = response.response?.statusCode else { return }
                switch response.result {
                case .success(let data):
                    do {
                        let value = try JSONDecoder().decode(T.self, from: data)
                        emitter.onNext((value, statusCode, nil))
                        
                    } catch {
                        emitter.onNext((nil, statusCode, nil))
                    }
                    
                case .failure(_):
                    guard let error = APIError(rawValue: statusCode) else { return }
                    emitter.onNext((nil, statusCode, nil))
                    emitter.onError(error)
                    
                }
                emitter.onCompleted()
            }
            
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }
}
