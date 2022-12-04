//
//  NearViewModel.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/19.
//

import Foundation

import RxSwift
import RxCocoa

final class NearViewModel: ViewModelType {
    
    var uid = ""
    let queueResponse = BehaviorSubject<Int>(value: 0)
    let requestResponse = BehaviorSubject<Int>(value: 0)
    let acceptResponse = BehaviorSubject<Int>(value: 0)
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(_ input: Input) -> Output {
        return Output()
    }
    
    // MARK: - Network
    
    /// 요청하기
    func requestStudyRequest(_ otheruid: String) {
        APIManager.shared.request(Int.self, QueueRouter.studyRequest(otheruid)) { [weak self] _, status, error in
            guard let self = self else { return }
            if let status = status {
                self.requestResponse.onNext(status)
            }
            if let error = error {
                ErrorManager.handle(with: error, vc: NearUserViewController(nearViewModel: NearViewModel(),
                                                                            searchViewModel: SearchViewModel()))
            }
        }
    }
    
    /// 수락하기
    func requestStudyAccept(_ otheruid: String) {
        APIManager.shared.request(Int.self, QueueRouter.studyAccept(otheruid)) { [weak self] _, status, error in
            guard let self = self else { return }
            if let status = status {
                self.acceptResponse.onNext(status)
            }
            if let error = error {
                ErrorManager.handle(with: error, vc: NearRequestViewController(nearViewModel: NearViewModel(),
                                                                               searchViewModel: SearchViewModel(), homeViewModel: HomeViewModel()))
            }
        }
    }
    
    /// 찾기 중단
    func requestStopQueue() {
        APIManager.shared.request(Int.self, QueueRouter.stopQueue) { [weak self] data, status, error in
            guard let self = self else { return }
            if let status = status {
                self.queueResponse.onNext(status)
            }
        }
    }
}
