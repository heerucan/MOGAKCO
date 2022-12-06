//
//  ReviewViewModel.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/12/06.
//

import Foundation

import RxSwift
import RxCocoa

final class ReviewViewModel: ViewModelType {
    
    let reviewResponse = BehaviorRelay<Int>(value: 0)
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(_ input: Input) -> Output {
        return Output()
    }
    
    // MARK: - Network
    
    func requestReview(uid: String, rate: RateRequest) {
        APIManager.shared.request(Int.self, QueueRouter.rate(uid, rate: rate)) { [weak self] _, status, error in
            guard let self = self else { return }
            if let status = status {
                self.reviewResponse.accept(status)
            }
            if let error = error {
                ErrorManager.handle(with: error, vc: ReviewViewController(ReviewViewModel()))
            }
        }
    }
}
