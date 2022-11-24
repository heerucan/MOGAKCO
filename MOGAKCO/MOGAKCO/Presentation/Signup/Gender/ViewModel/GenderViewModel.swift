//
//  GenderViewModel.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/09.
//

import Foundation

import RxSwift
import RxCocoa

final class GenderViewModel: ViewModelType {
    
    typealias SignupCompletion = (Int?, APIError?)
    let signupResponse = PublishSubject<SignupCompletion>()
    
    struct Input {
        let genderIndex: ControlEvent<IndexPath>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let gender: Observable<[Gender]>
        let tap: Observable<ControlEvent<IndexPath>.Element>
        let genderIndex: ControlEvent<IndexPath>
        let response: PublishSubject<SignupCompletion>
    }
    
    func transform(_ input: Input) -> Output {
        let genderIndex = input.genderIndex
        let genderList = Observable.just(GenderData().list)
        
        let nextTap = input.tap
            .withLatestFrom(genderIndex)
                
        return Output(gender: genderList,
                      tap: nextTap,
                      genderIndex: genderIndex,
                      response: signupResponse)
    }
    
    // MARK: - Network
    
    func requestSignup() {
        let params = SignupRequest(phoneNumber: UserDefaultsHelper.standard.phone ?? "",
                                   FCMtoken: APIKey.FCMtoken,
                                   nick: UserDefaultsHelper.standard.nickname ?? "",
                                   birth: UserDefaultsHelper.standard.birthday ?? "",
                                   email: UserDefaultsHelper.standard.email ?? "",
                                   gender: UserDefaultsHelper.standard.gender)
        
        APIManager.shared
            .request(SignupRequest.self, AuthRouter.signup(params)) { [weak self] data, status, error in
            guard let self = self else { return }
            self.signupResponse.onNext(SignupCompletion(status, error))
            if let error = error {
                self.signupResponse.onError(error)
            }
        }
    }
}
