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
    
    let nearStudyListRelay = BehaviorRelay<[String]>(value: [])
    let friendStudyListRelay = BehaviorRelay<[String]>(value: [])
    let myStudyListRelay = BehaviorRelay<[String]>(value: [])
    var myStudyList: [String] = []

    struct Input {
//        let findButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let searchResponse: BehaviorSubject<Search>
//        let findButtonTap: Observable<APIError>
    }
    
    func transform(_ input: Input) -> Output {
        
//        let tap = input.findButtonTap
//            .withLatestFrom(queueResponse)
        
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
                ErrorManager.handle(with: error, vc: SearchViewController(homeViewModel: HomeViewModel(), searchViewModel: SearchViewModel()))
            }
        }
    }
    
    // 새싹찾기 버튼 클릭
    func requestFindQueue() {
        
        let params = FindRequest(long: UserDefaultsHelper.standard.lng!,
                                 lat: UserDefaultsHelper.standard.lat!,
                                 studylist: checkStudyListIsEmpty())
        
        APIManager.shared.request(Int.self, QueueRouter.findQueue(params)) { [weak self] data, status, error in
            guard let self = self else { return }
            if let status = status {
                self.queueResponse.accept(status)
            }
            if let error = error {
                ErrorManager.handle(with: error, vc: SearchViewController(homeViewModel: HomeViewModel(), searchViewModel: SearchViewModel()))
            }
        }
    }
    
    // MARK: - Logic
    
    // 지금 주변에는 - 중복된 스터디 제거
    @discardableResult
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
        friendStudyListRelay.accept(Array(resultSet))
        
        var array: [String] = []
        array.append(contentsOf: value.fromRecommend)
        array.append(contentsOf: Array(resultSet))
        nearStudyListRelay.accept(value.fromRecommend)
        
        return Array(resultSet)
    }
    
    // 추천 스터디 개수 가져와서 색 나눠주기
    func recommendCount() -> Int {
        return nearStudyListRelay.value.count
    }

    // 스터디가 빈배열인 경우 "anything" 전송
    func checkStudyListIsEmpty() -> [String] {
        var studylist: [String] = []
        let currentStudylist = myStudyListRelay.value
        currentStudylist.isEmpty ? studylist.append("anything") : studylist.append(contentsOf: currentStudylist)
        return studylist
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
                completion(Toast.studyCount.message)
            } else if myStudyList.contains($0) || list.contains($0) {
                completion(Toast.alreadyStudy.message)
            } else {
                myStudyList.append($0)
            }
        }
        myStudyListRelay.accept(myStudyList)
    }
    
    // 해당 배열에 포함되어 있니?
    func myStudyContains(_ value: String) -> Bool {
        if myStudyListRelay.value.contains(value) {
            return true
        } else {
            return false
        }
    }
    
    func friendStudyContains(_ value: String) -> Bool {
        if friendStudyListRelay.value.contains(value) {
            return true
        } else {
            return false
        }
    }
    
    func nearStudyContains(_ value: String) -> Bool {
        if nearStudyListRelay.value.contains(value) {
            return true
        } else {
            return false
        }
    }
}
