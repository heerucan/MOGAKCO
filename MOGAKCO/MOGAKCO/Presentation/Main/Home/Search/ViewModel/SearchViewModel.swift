//
//  SearchViewModel.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/19.
//

import Foundation

import RxSwift
import RxCocoa

final class SearchViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    let searchResponse = BehaviorSubject<Search>(value: Search(fromQueueDB: [], fromQueueDBRequested: [], fromRecommend: []))
    let queueResponse = PublishRelay<Int>()
    
    let myStudyListRelay = BehaviorRelay<[String]>(value: [])
    var myStudyList: [String] = []

    struct Input {
        
    }
    
    struct Output {
        let searchResponse: BehaviorSubject<Search>
    }
    
    func transform(_ input: Input) -> Output {
        
        return Output(searchResponse: searchResponse)
    }
    
    // MARK: - Network
    
    // 스터디리스트 가져오기
    func requestSearch(lat: Double, long: Double) {
        
        let params = SearchRequest(lat: lat, long: long)
        
        APIManager.shared.request(Search.self, QueueRouter.search(params)) { [weak self] data, status, error in
            guard let self = self else { return }
            if let data = data {
                self.searchResponse.onNext(data)
            }
            if let error = error {
                self.searchResponse.onError(error)
            }
        }
    }
    
    // 새싹찾기 버튼 클릭
    func requestFindQueue(long: Double, lat: Double, studylist: [String]) {
        
        let params = FindRequest(long: long, lat: lat, studylist: studylist)
        
        APIManager.shared.request(Int.self, QueueRouter.findQueue(params)) { [weak self] data, status, error in
            guard let self = self else { return }
            if let status = status {
                self.queueResponse.accept(status)
            }
        }
    }
    
    // MARK: - Business Logic
    
    // 지금 주변에는 - 중복된 스터디 제거
    func deleteDuplicateStudy(_ value: Search) -> [String] {
        var friendList: [String] = []
        
        value.fromQueueDB.forEach { queue in
            queue.studylist.forEach { result in
                friendList.append(result)
            }
        }
        value.fromQueueDBRequested.forEach { queue in
            queue.studylist.forEach { result in
                friendList.append(result)
            }
        }

        let recommendSet = Set(value.fromRecommend)
        let friendSet = Set(friendList.map { $0.lowercased() }.sorted(by: >))
        let resultSet = friendSet.subtracting(recommendSet.map { $0.lowercased()})
        return Array(resultSet)
    }
    
    // 추천 스터디 개수 가져와서 색 나눠주기
    func recommendCount() -> Int {
        var list: [String] = []
        searchResponse.bind { result in
            list.append(contentsOf: result.fromRecommend)
        }
        .disposed(by: disposeBag)
        
        return list.count
    }
    
    // 내 스터디 글자 개수 체크 + 기존에 등록된 스터디 체크
    func addMyStudyList(_ searchText: [String], completion: ((String) -> Void)) {

        var list: [String] = []
        searchResponse.bind { result in
            list.append(contentsOf: self.deleteDuplicateStudy(result))
        }
        .disposed(by: disposeBag)
                
        searchText.forEach {
            if $0.count < 1 || $0.count > 8 {
                completion(ToastMatrix.studyCount.description)
            } else if myStudyList.contains($0) || list.contains($0) {
                completion(ToastMatrix.alreadyStudy.description)
            } else {
                myStudyList.append($0)
            }
        }
        myStudyListRelay.accept(myStudyList)
    }
}
