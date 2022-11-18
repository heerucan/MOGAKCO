//
//  HomeViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/13.
//

import UIKit

import CoreLocation
import RxSwift
import RxCocoa
import SnapKit
import Then
import NMapsMap

final class HomeViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
        
    // MARK: - Property
    
    private let homeView = HomeView()
    private let homeViewModel = HomeViewModel()
    
    private let geocoder = CLGeocoder()
    
    private let locationManager = CLLocationManager()
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        UserDefaultsHelper.standard.currentUser = true
    }
    
    // MARK: - UI & Layout

    override func setupDelegate() {
        homeView.setupMapDelegate(self, self)
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = HomeViewModel.Input(tap: homeView.locationButton.rx.tap)
        let output = homeViewModel.transform(input)

        // TODO: - 컬렉션뷰 처리
        
        output.tagList
            .bind(to: homeView.collectionView.rx.items(
                cellIdentifier: HomeTagCollectionViewCell.identifier,
                cellType: HomeTagCollectionViewCell.self)) { index, item, cell in
                    cell.setupData(data: item)
                }
                .disposed(by: disposeBag)
        
        homeView.collectionView.rx.itemSelected
            .withUnretained(self)
            .bind { vc, item in
                print(item)
            }
            .disposed(by: disposeBag)
        
        // TODO: - 로케이션 매니저 처리
        
        // 뷰모델에서 코디네이트 가져와서 맵뷰 초기값 세팅
        homeViewModel.locationSubject // output
            .compactMap { $0 } // 옵셔널 바인딩
            .withUnretained(self)
            .subscribe { vc, coordinate in
                vc.homeView.mapView.latitude = coordinate.latitude
                vc.homeView.mapView.longitude = coordinate.longitude
            }
            .disposed(by: disposeBag)
        
        locationManager.rx.didUpdateLocations
            .compactMap { $0.last?.coordinate } // 1차원 배열에서 nil 제거, 옵셔널 바인딩
            .withUnretained(self)
            .subscribe { vc, coordinate in
                vc.homeViewModel.locationSubject.onNext(coordinate)
                print(coordinate.latitude, coordinate.longitude)
                vc.updateCurrentLocation()
            }
            .disposed(by: disposeBag)

        locationManager.rx.didFailWithError
            .withUnretained(self)
            .subscribe(onNext: { vc, error in
                print("😡 사용자의 위치를 가져오지 못했습니다.", error)
                vc.checkUserCurrentLocationAuthorization(vc.locationManager.authorizationStatus)
            })
            .disposed(by: disposeBag)
        
        locationManager.rx.didChangeAuthorizationStatus
            .withUnretained(self)
            .subscribe(onNext: { vc, status in
                if CLLocationManager.locationServicesEnabled() {
                    vc.checkUserCurrentLocationAuthorization(status)
                } else {
                    vc.showLocationServiceAlert()
                }
            })
            .disposed(by: disposeBag)
        
        locationManager.startUpdatingLocation()
        
        // TODO: - 네이버맵 처리
        
        
        
    }
    
    // MARK: - Map
    
    private func updateCurrentLocation() {
        guard let lat = locationManager.location?.coordinate.latitude,
              let long = locationManager.location?.coordinate.longitude else { return }
        locationManager.stopUpdatingLocation()
        let coordinate = NMGLatLng(lat: lat, lng: long)
        let cameraUpdate = NMFCameraUpdate(scrollTo: coordinate, zoomTo: 14)
        cameraUpdate.animation = .linear
        homeView.mapView.moveCamera(cameraUpdate)
    }
}

// MARK: - Naver Map Protocol

extension HomeViewController: NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
    
}

// MARK: - CLLocation Manager Protocol

extension HomeViewController {
    private func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("아직 결정 X")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("거부 or 아이폰 설정 유도")
            showLocationServiceAlert()
        case .authorizedWhenInUse, .authorizedAlways:
            print("🤩 WHEN IN USE or ALWAYS")
            locationManager.startUpdatingLocation() // 정확도를 위해서 무한대로 호출
        default:
            print("DEFAULT")
        }
    }
    
    private func showLocationServiceAlert() {
        let setting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let setting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(setting)
            }
        }
        showAlert(title: "위치 정보 이용",
                  message: Matrix.settingMessage,
                  actions: [setting],
                  preferredStyle: .alert)
    }
}
