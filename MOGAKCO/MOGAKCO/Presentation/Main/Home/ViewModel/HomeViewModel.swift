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
    
    let ssacCoordinate = CLLocationCoordinate2D(latitude: Matrix.ssacLat, longitude: Matrix.ssacLong)
    let tagList = Observable.just(["전체", "남자", "여자"])
    lazy var locationSubject = BehaviorSubject<CLLocationCoordinate2D?>(value: ssacCoordinate)
    
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
    
    func updateCurrentLocation(_ coordinate: CLLocationCoordinate2D, completion: @escaping ((NMFCameraUpdate) -> ())) {
        LocationManager.shared.stopUpdatingLocation()
        let coordinate = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
        let cameraUpdate = NMFCameraUpdate(scrollTo: coordinate, zoomTo: 14)
        cameraUpdate.animation = .linear
        completion(cameraUpdate)
    }
}

