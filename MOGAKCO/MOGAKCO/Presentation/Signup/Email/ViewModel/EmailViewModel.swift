//
//  EmailViewModel.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/10.
//

import Foundation

import RxSwift
import RxCocoa

final class EmailViewModel: ViewModelType {
    
    let email = PublishRelay<String>()
    
    struct Input {
        let emailTap: ControlEvent<Void>
    }
    
    struct Output {
        let emailTap: ControlEvent<Void>
    }
    
    func transform(_ input: Input) -> Output {
        return Output(emailTap: input.emailTap)
    }
    
    func checkEmail(with phoneText: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: phoneText.addHyphen())
    }
}
