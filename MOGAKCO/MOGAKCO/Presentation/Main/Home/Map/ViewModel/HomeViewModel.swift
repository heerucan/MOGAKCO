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
    
    typealias SearchCompletion = (Search?, Int?, APIError?)
    typealias QueueStateCompletion = (QueueState?, Int?, APIError?)
    let searchResponse = PublishSubject<SearchCompletion>()
    let queueStateResponse = PublishSubject<QueueStateCompletion>()
    let markerRelay = PublishRelay<[NMFMarker]>()
    
    let tagList = Observable.just(["전체", "남자", "여자"])
    
    lazy var locationSubject = BehaviorSubject<CLLocationCoordinate2D?>(
        value: CLLocationCoordinate2D(
        latitude: Matrix.ssacLat,
        longitude: Matrix.ssacLong))
    
    struct Input {
        let locationTap: ControlEvent<Void>
        let itemSelected: ControlEvent<IndexPath>
    }
    
    struct Output {
        let locationTap: Observable<CLLocationCoordinate2D?>
        let itemSelected: ControlEvent<IndexPath>
        let tagList: Observable<[String]>
        let searchResponse: PublishSubject<SearchCompletion>
        let queueStateResponse: PublishSubject<QueueStateCompletion>
    }
    
    func transform(_ input: Input) -> Output {
        let tagList = Observable.just(["전체", "남자", "여자"])
        
        let myLocationButtonTap = input.locationTap
            .withLatestFrom(locationSubject)
        
        let itemSelected = input.itemSelected
        
        return Output(locationTap: myLocationButtonTap,
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
                ErrorManager.handle(with: error, vc: HomeViewController())
            }
        }
    }
    
    func requestQueueState() {
        APIManager.shared
            .request(QueueState.self, QueueRouter.myQueueState) { [weak self] data, status, error in
            guard let self = self else { return }
            self.queueStateResponse.onNext(QueueStateCompletion(data, status, error))
            if let error = error {
                ErrorManager.handle(with: error, vc: HomeViewController())
            }
        }
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
    
    func updateCurrentLocation(_ coordinate: CLLocationCoordinate2D,
                               completion: @escaping ((NMFCameraUpdate) -> ())) {
        LocationManager.shared.stopUpdatingLocation()
        let coordinate = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
        let cameraUpdate = NMFCameraUpdate(scrollTo: coordinate, zoomTo: 14)
        cameraUpdate.animation = .linear
        completion(cameraUpdate)
    }
}
