//
//  GeoLocationService.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/17.
//

import Foundation

import CoreLocation
import RxCocoa
import RxSwift
import RxCoreLocation


final class GeoLocationService {
    static let shared = GeoLocationService()
    
    private let disposeBag = DisposeBag()
    
    private (set) var authorized = BehaviorSubject<Bool>(value: false) // 권한
    private (set) var location = BehaviorSubject<CLLocationCoordinate2D?>(value: nil)
    
    private let locationManager = CLLocationManager()
    
    private lazy var defaultLat = 37.517819364682694
    private lazy var defaultLong = 126.88647317074734
    
    private init() { // 실시간 위치 구독해서 locationSubject에 입력
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        
        locationManager.rx.didUpdateLocations
            .compactMap(\.locations.last?.coordinate)
            .bind(onNext: location.onNext(_:))
            .disposed(by: disposeBag)
                
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func requestLocation() -> Observable<CLAuthorizationStatus> {
        return Observable<CLAuthorizationStatus>.deferred { [weak self] in
            guard let auth = self else { return .empty() }
            auth.locationManager.requestWhenInUseAuthorization()
            return auth.locationManager
                .rx.didChangeAuthorization
                .map { $1 }
                .map {
                    switch $0 {
                    case .notDetermined:
                        print("아직 결정 X")
                        auth.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                        auth.locationManager.requestWhenInUseAuthorization()
                    case .restricted, .denied:
                        print("거부 또는 아이폰 설정 유도")
                    case .authorizedAlways, .authorizedWhenInUse:
                        auth.locationManager.startUpdatingLocation()
                    default: print("DEFAULT")
                    }
                    return $0
                }
                .filter { $0 != .notDetermined }
                .do(onNext: { _ in
                    auth.locationManager.startUpdatingLocation() })
                    .take(1)
                    }
    }
}
