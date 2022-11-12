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
    
    let loginResponse = PublishSubject<Login>()
    
    struct Input {
        let messageText: ControlProperty<String?>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let messageText: ControlProperty<String>
        let tap: Observable<Bool>
        let messageValid: Driver<Bool>
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
                
        return Output(messageText: text, tap: nextTap, messageValid: messageValid)
    }
    
    func requestLogin() {
        
//        APIManager.shared.requestData(Login.self, UserRouter.login)
//            .map { result in
//                print(result)
//                switch result {
//                case .success(let value):
//                    self.loginResponse.onNext(value)
//                case .failure(let error):
//                    self.loginResponse.onError(error)
//                }
//            }
        
//        APIManager.shared.requestData(Login.self, UserRouter.login) { result in
//            switch result {
//            case .success(let value):
//                print(value)
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
}
