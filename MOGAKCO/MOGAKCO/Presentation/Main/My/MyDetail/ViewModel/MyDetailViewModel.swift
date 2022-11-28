//
//  MyDetailViewModel.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/14.
//

import UIKit

import RxSwift
import RxCocoa

final class MyDetailViewModel: ViewModelType {
    
    var userResponse = BehaviorSubject<[User]>(value: [])
    let withdrawResponse = BehaviorSubject<Int>(value: 0)
    
    let disposeBag = DisposeBag()
    
    struct Input {
//        let tap: ControlEvent<Void>
    }
    
    struct Output {
//        let tap: Observable<(PublishSubject<Int>, ControlEvent<Void>.Element)>
    }
    
    func transform(_ input: Input) -> Output {
//        let response = userResponse.map { $0.0 }

        return Output()
    }
    
    // MARK: - Network
    
    func requestUser() {
        APIManager.shared.request(User.self, AuthRouter.login) { [weak self] data, status, error in
            guard let self = self else { return }
            if let data = data {
                self.userResponse.onNext([data, data])
            }
            if let error = error {
                ErrorManager.handle(with: error, vc: MyDetailViewController())
            }
        }
    }
    
    func requestWithdraw() {
        APIManager.shared.request(Int.self, AuthRouter.withdraw) { [weak self] data, status, error in
            guard let self = self else { return }
            if let status = status {
                self.withdrawResponse.onNext(status)
            }
            if let error = error {
                ErrorManager.handle(with: error, vc: MyDetailViewController())
            }
        }
        
    }
        
//        APIManager.shared.requestData(Int.self, AuthRouter.withdraw) { [weak self] response in
//            guard let self = self else { return }
//            switch response {
//            case .success(let value):
//                print("🟣성공 ->>> \n", value)
//                self.handle(with: .success)
//                UserDefaultsHelper.standard.removeObject()
//                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
//                let sceneDelegate = windowScene?.delegate as? SceneDelegate
//                let viewController = OnboardingViewController()
//                sceneDelegate?.window?.rootViewController = viewController
//                sceneDelegate?.window?.makeKeyAndVisible()
//
//            case .failure(let error):
//                self.handle(with: error)
//                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
//                let sceneDelegate = windowScene?.delegate as? SceneDelegate
//                let viewController = OnboardingViewController()
//                sceneDelegate?.window?.rootViewController = viewController
//                sceneDelegate?.window?.makeKeyAndVisible()
//            }
//        }
}
