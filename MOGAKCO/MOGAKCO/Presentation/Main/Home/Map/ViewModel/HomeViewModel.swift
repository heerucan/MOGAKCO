//
//  HomeViewModel.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/14.
//

import Foundation

import CoreLocation
import RxSwift
import RxCocoa
import NMapsMap


final class HomeViewModel: ViewModelType {
    
    var myQueueStateAPITimer = Timer()
    
    typealias SearchCompletion = (Search?, Int?, APIError?)
    let searchResponse = PublishSubject<SearchCompletion>()
    let queueStateResponse = PublishRelay<Int>()
    let markerRelay = PublishRelay<[NMFMarker]>()
    
    let tagList = Observable.just(["전체", "남자", "여자"])
    
    let locationSubject = BehaviorSubject<CLLocationCoordinate2D?>(
        value: CLLocationCoordinate2D(
        latitude: Matrix.ssacLat,
        longitude: Matrix.ssacLong))
    
    var matchedArray = [String]()
    
    struct Input {
        let locationTap: ControlEvent<Void>
        let itemSelected: ControlEvent<IndexPath>
    }
    
    struct Output {
        let locationTap: ControlEvent<Void>
        let itemSelected: ControlEvent<IndexPath>
        let tagList: Observable<[String]>
        let searchResponse: PublishSubject<SearchCompletion>
        let queueStateResponse: PublishRelay<Int>
    }
    
    func transform(_ input: Input) -> Output {
        let tagList = Observable.just(["전체", "남자", "여자"])
                
        let itemSelected = input.itemSelected
        
        return Output(locationTap: input.locationTap,
                      itemSelected: itemSelected,
                      tagList: tagList,
                      searchResponse: searchResponse,
                      queueStateResponse: queueStateResponse)
    }
    
    // MARK: - Network
    
    func requestSearch(params: SearchRequest) {
        APIManager.shared
            .request(Search.self, QueueRouter.search(params)) { [weak self] data, status, error in
            guard let self = self else { return }
            self.searchResponse.onNext(SearchCompletion(data, status, error))
            if let error = error {
                ErrorManager.handle(with: error, vc: HomeViewController(HomeViewModel()))
            }
        }
    }
    
    func requestQueueState() {
        APIManager.shared
            .request(QueueState.self, QueueRouter.myQueueState) { [weak self] data, status, error in
                guard let self = self else { return }
                if let data = data {
                    self.queueStateResponse.accept(data.matched)
                } else {
                    self.queueStateResponse.accept(status!)
                }
                
                if let nick = data?.matchedNick,
                   let uid = data?.matchedUid {
                    self.matchedArray.append(contentsOf: [nick, uid])
                }
                
                if let error = error {
                    ErrorManager.handle(with: error, vc: HomeViewController(HomeViewModel()))
                }
            }
    }

    func searchAroundFriend(lat: Double, lng: Double) {
        requestSearch(params: SearchRequest(lat: lat, long: lng))
    }
    
    // MARK: - myQueueState 5초마다 반복 호출
    
    /// myQueueStateAPI 반복호출
    func requestRepeatedMyQueueStateAPI() {
        myQueueStateAPITimer = Timer.scheduledTimer(timeInterval: 5,
                             target: self,
                             selector: #selector(requestMyQueueStateAPI(sender:)),
                             userInfo: nil,
                             repeats: true)
    }
    
    /// myQueueStateAPI 호출중단 - 매칭 완료 시에 종료!!!!
    func stopRepeatedMyQueueStateAPI() {
        myQueueStateAPITimer.invalidate()
    }
    
    @objc func requestMyQueueStateAPI(sender: Timer) {
        requestQueueState()
    }
    
    
    // MARK: - Location Authorization
    
    func checkUserAuthorization(_ status: CLAuthorizationStatus,
                                completion: @escaping ((CLAuthorizationStatus?) -> ())) {
        switch status {
        case .notDetermined:
            print("아직 결정 X")
            LocationManager.shared.desiredAccuracy = kCLLocationAccuracyBest
            LocationManager.shared.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("거부 or 아이폰 설정 유도")
            completion(status)
        case .authorizedWhenInUse, .authorizedAlways:
            print("🤩 WHEN IN USE or ALWAYS")
            LocationManager.shared.startUpdatingLocation()
        default:
            print("DEFAULT")
        }
    }
    
    func updateCurrentLocation() -> NMFCameraUpdate {
        LocationManager.shared.stopUpdatingLocation()
        let coordinate = NMGLatLng(
            lat: LocationManager.coordinate().latitude,
            lng: LocationManager.coordinate().longitude)
        locationSubject.onNext(LocationManager.coordinate())
        let cameraUpdate = NMFCameraUpdate(scrollTo: coordinate, zoomTo: 14)
        cameraUpdate.animation = .linear
        return cameraUpdate
    }
}
