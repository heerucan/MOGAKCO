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
    
    let tagList = Observable.just(["전체", "남자", "여자"])
        
    lazy var locationSubject = BehaviorSubject<CLLocationCoordinate2D?>(value: CLLocationCoordinate2D(latitude: Matrix.ssacLat,
                                                                                                      longitude: Matrix.ssacLong))
    let searchResponse = PublishSubject<Search>()
    let queueStateResponse = PublishSubject<QueueState>()
    
    struct Input {
        let locationTap: ControlEvent<Void>
    }
    
    struct Output {
        let locationTap: Observable<CLLocationCoordinate2D?>
        let tagList: Observable<[String]>
    }
    
    func transform(_ input: Input) -> Output {
        let tagList = Observable.just(["전체", "남자", "여자"])
        
        let myLocationButtonTap = input.locationTap
            .withLatestFrom(locationSubject)
                
        return Output(locationTap: myLocationButtonTap, tagList: tagList)
    }
    
    // MARK: - Network

    func requestSearch(params: SearchRequest) {
        APIManager.shared.request(Search.self, QueueRouter.search(params)) { [weak self] data, status, error in
            guard let self = self else { return }
            guard let status = status else { return }
            if let data = data {
                self.searchResponse.onNext(data)
            }
            
            if let error = error {
                self.searchResponse.onError(error)
            }
        }
    }
    
    func requestQueueState() {
        APIManager.shared.request(QueueState.self, QueueRouter.myQueueState) { [weak self] data, status, error in
            guard let self = self else { return }
            guard let status = status else { return }
            if let data = data {
                self.queueStateResponse.onNext(data)
            }
            
            if let error = error {
                self.queueStateResponse.onError(error)
            }
        }
    }
    
    // MARK: - Location Authorization
    
    func checkUserAuthorization(_ status: CLAuthorizationStatus, completion: @escaping ((CLAuthorizationStatus?) -> ())) {
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
            LocationManager.shared.startUpdatingLocation() // 정확도를 위해서 무한대로 호출
        default:
            print("DEFAULT")
        }
    }
    
    func updateCurrentLocation(_ coordinate: CLLocationCoordinate2D, completion: @escaping ((NMFCameraUpdate) -> ())) {
        LocationManager.shared.stopUpdatingLocation()
        let coordinate = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
        let cameraUpdate = NMFCameraUpdate(scrollTo: coordinate, zoomTo: 14)
        cameraUpdate.animation = .linear
        completion(cameraUpdate)
    }
}
