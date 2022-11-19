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
    
    typealias LoginCompletion = (Login?, Int?, APIError?)
    let loginResponse = PublishSubject<LoginCompletion>()
    
    struct Input {
        let messageText: ControlProperty<String?>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let messageText: ControlProperty<String>
        let tap: Observable<Bool>
        let messageValid: Driver<Bool>
        let response: PublishSubject<LoginCompletion>
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
                        
        return Output(messageText: text,
                      tap: nextTap,
                      messageValid: messageValid,
                      response: loginResponse)
    }
    
    // MARK: - Network
    
    func requestLogin() {
        APIManager.shared.request(Login.self, AuthRouter.login) { [weak self] data, status, error in
            guard let self = self else { return }
            self.loginResponse.onNext(LoginCompletion(data, status, error))
            if let error = error {
                self.loginResponse.onError(error)
            }
        }
    }
}
