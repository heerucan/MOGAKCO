//
//  HomeViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/13.
//

import UIKit

import CoreLocation
import RxSwift
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
    
    private let locationManager = CLLocationManager().then {
        $0.distanceFilter = 10000
    }
    
    private lazy var myLatitude = locationManager.location?.coordinate.latitude
    private lazy var myLongtitude = locationManager.location?.coordinate.longitude
    
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
    
    override func configureUI() {
        view.backgroundColor = .red
    }
    
    override func configureLayout() {
        
    }
    
    override func setupDelegate() {
        locationManager.delegate = self
        homeView.setupMapDelegate(self, self)
//        homeView.setupCollectionViewDelegate(self, self)
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
//        let input = HomeViewModel.Input(tap: button.rx.tap)
//        let output = homeViewModel.transform(input)

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

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            myLatitude = coordinate.latitude
            myLongtitude = coordinate.longitude
            updateCurrentLocation()
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("😡 사용자의 위치를 가져오지 못했습니다.")
        checkUserCurrentLocationAuthorization(locationManager.authorizationStatus)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationServiceAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkUserDeviceLocationServiceAuthorization()
    }
}

// MARK: - 위치 서비스 활성화 체크

extension HomeViewController {
    private func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        authorizationStatus = locationManager.authorizationStatus
        
        if CLLocationManager.locationServicesEnabled() {
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            showLocationServiceAlert()
        }
    }
    
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
                  message: "",
                  actions: [setting],
                  preferredStyle: .alert)
    }
}
