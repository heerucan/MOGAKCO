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
    
    let queueResponse = BehaviorSubject<Int>(value: 0)
    let requestResponse = BehaviorSubject<Int>(value: 0)
    let acceptResponse = BehaviorSubject<Int>(value: 0)
    var uid: String = ""
    
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
            print(status, error, "============requestStudyRequest")
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
            print(status, error, "============requestStudyAccept")
            guard let self = self else { return }
            // 200 -> 수락 시에 채팅화면으로!
            // 201 -> “상대방이 이미 다른 새싹과 스터디를 함께 하는 중입니다”
            // 202 -> “상대방이 스터디 찾기를 그만두었습니다”
            // 203 -> 앗! 누군가가 나의 스터디를 수락하였어요 -> (get, /v1/queue/myQueueState)
            if let status = status {
                self.acceptResponse.onNext(status)
            }
            if let error = error {
                ErrorManager.handle(with: error, vc: NearRequestViewController(nearViewModel: NearViewModel(), searchViewModel: SearchViewModel()))
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
