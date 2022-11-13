//
//  MessageViewModel.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/09.
//

import Foundation

import RxSwift
import RxCocoa

final class MessageViewModel: ViewModelType {
    
    let loginResponse = PublishSubject<Result<Login, APIError>>()
    
    struct Input {
        let messageText: ControlProperty<String?>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let messageText: ControlProperty<String>
        let tap: Observable<Bool>
        let messageValid: Driver<Bool>
        let loginResponse: PublishSubject<Result<Login, APIError>>
    }
    
    func transform(_ input: Input) -> Output {
        let messageValid = input.messageText
            .orEmpty
            .map { value in
                value.count == 6 ? true : false
            }
            .asDriver(onErrorJustReturn: false)
        
        let text = input.messageText.orEmpty
        
        let nextTap = input.tap
            .withLatestFrom(messageValid)
        
        let response = loginResponse
                
        return Output(messageText: text, tap: nextTap, messageValid: messageValid, loginResponse: response)
    }
    
    func requestLogin() {
        APIManager.shared.requestData(Login.self, UserRouter.login) { result  in
            self.loginResponse.onNext(result)
//            switch result {
//            case .success(let value):
//                print(value)
//                self.loginResponse.onNext(value)
//            case .failure(let error):
//                self.loginResponse.onError(error)
//                print("VM ->>>", error.errorDescription)
//            }
        }
    }
}
