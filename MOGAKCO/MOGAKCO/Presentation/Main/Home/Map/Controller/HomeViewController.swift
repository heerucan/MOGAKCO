//
//  HomeViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/13.
//

import UIKit

// TODO: - search 재귀호출 체크해보기

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
    
    private lazy var target = homeView.mapView.cameraPosition.target
    var markers: [NMFMarker] = []

    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        UserDefaultsHelper.standard.currentUser = true
        print(UserDefaultsHelper.standard.idToken)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeViewModel.requestQueueState()
        searchSSAC()
    }
    
    // MARK: - UI & Layout
    
    override func configureUI() {
        super.configureUI()
    }
    
    override func setupDelegate() {
        homeView.setupMapDelegate(self, self)
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = HomeViewModel.Input(
            locationTap: homeView.locationButton.rx.tap,
            itemSelected: homeView.collectionView.rx.itemSelected)
        let output = homeViewModel.transform(input)
        
        homeViewModel.locationSubject
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe { vc, coordinate in
                vc.homeView.mapView.latitude = coordinate.latitude
                vc.homeView.mapView.longitude = coordinate.longitude
            }
            .disposed(by: disposeBag)
        
        LocationManager.shared.rx.didUpdateLocations
            .compactMap { $0.last?.coordinate }
            .withUnretained(self)
            .subscribe { vc, coordinate in
                vc.searchSSAC()
                vc.homeViewModel.locationSubject.onNext(coordinate)
                vc.homeViewModel.updateCurrentLocation(coordinate) { cameraUpdate in
                    vc.homeView.mapView.moveCamera(cameraUpdate)
                }
            }
            .disposed(by: disposeBag)
        
        LocationManager.shared.rx.didFailWithError
            .withUnretained(self)
            .subscribe(onNext: { vc, error in
                vc.homeViewModel.checkUserAuthorization(LocationManager.shared.authorizationStatus) { status in
                    vc.showLocationServiceAlert()
                }
            })
            .disposed(by: disposeBag)
        
        LocationManager.shared.rx.didChangeAuthorizationStatus
            .withUnretained(self)
            .subscribe(onNext: { vc, status in
                if CLLocationManager.locationServicesEnabled() {
                    vc.homeViewModel.checkUserAuthorization(status) { status in
                        status == .denied || status == .restricted ?
                        vc.showLocationServiceAlert() : vc.searchSSAC()
                    }
                } else {
                    vc.showLocationServiceAlert()
                }
            })
            .disposed(by: disposeBag)
        
        /// 마커찍기
        output.searchResponse
            .withUnretained(self)
            .subscribe { vc, response in
                if let search = response.0 {
                    vc.setupMarker(search.fromQueueDB)
                    vc.setupMarker(search.fromQueueDBRequested)
                }
            }
            .disposed(by: disposeBag)
        
        /// 성별 필터
        homeView.allButton.rx.tap
            .withLatestFrom(homeView.allButton.rx.isHighlighted)
            .filter { $0 == true }
            .map { !$0 }
            .withUnretained(self)
            .bind { vc, value in
                vc.homeView.allButton.isSelected = !value
                vc.homeView.maleButton.isSelected = value
                vc.homeView.femaleButton.isSelected = value
            }
            .disposed(by: disposeBag)
                
        homeView.femaleButton.rx.tap
            .withLatestFrom(homeView.femaleButton.rx.isHighlighted)
            .filter { $0 == true }
            .map { !$0 }
            .withUnretained(self)
            .bind { vc, value in
                vc.homeView.femaleButton.isSelected = !value
                vc.homeView.maleButton.isSelected = value
                vc.homeView.allButton.isSelected = value
            }
            .disposed(by: disposeBag)
        
        homeView.maleButton.rx.tap
            .withLatestFrom(homeView.maleButton.rx.isHighlighted)
            .filter { $0 == true }
            .map { !$0 }
            .withUnretained(self)
            .bind { vc, value in
                vc.homeView.maleButton.isSelected = !value
                vc.homeView.femaleButton.isSelected = value
                vc.homeView.allButton.isSelected = value
            }
            .disposed(by: disposeBag)
        
        
//        homeView.allButton.rx.tap
//            .withLatestFrom(output.searchResponse)
//            .withUnretained(self)
//            .subscribe { vc, value in
////                vc.setMarker(value.0!.fromQueueDB)
////                vc.setMarker(value.0!.fromQueueDBRequested)
//            }
//            .disposed(by: disposeBag)
//
//        homeView.femaleButton.rx.tap
//            .withLatestFrom(output.searchResponse)
//            .withUnretained(self)
//            .subscribe { vc, value in
////                marker.mapView = nil
////                vc.setMarker(gender: 0, value.0!.fromQueueDB)
////                vc.setMarker(gender: 0, value.0!.fromQueueDBRequested)
//            }
//            .disposed(by: disposeBag)
//
//        homeView.maleButton.rx.tap
//            .withLatestFrom(output.searchResponse)
//            .withUnretained(self)
//            .subscribe { vc, value in
////                vc.setMarker(gender: 1, value.0!.fromQueueDB)
////                vc.setMarker(gender: 1, value.0!.fromQueueDBRequested)
//            }
//            .disposed(by: disposeBag)
        
        
        /// 내 위치 버튼
        output.locationTap
            .compactMap { $0 }
            .withUnretained(self)
            .bind { vc, coordinate in
                LocationManager.shared.startUpdatingLocation()
                vc.homeViewModel.updateCurrentLocation(
                    CLLocationCoordinate2D(
                        latitude: vc.target.lat,
                        longitude: vc.target.lng)) { cameraUpdate in
                    vc.homeView.mapView.moveCamera(cameraUpdate)
                }
            }
            .disposed(by: disposeBag)
        
        /// 매칭 버튼
        homeView.matchingButton.rx.tap
            .withLatestFrom(homeViewModel.queueStateResponse)
            .map { $0 }
            .withUnretained(self)
            .bind { vc, value in
                print(value, "여기")
                guard let data = value.0?.matched else { return }
                guard let status = value.1 else { return }
                if data == 0 && status == 201 {
                    vc.setupMatchingButton(MatchingButton.matched)
                } else if data == 1 && status == 201 {
                    vc.setupMatchingButton(MatchingButton.matching)
                } else {
                    vc.setupMatchingButton(MatchingButton.normal)
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Custom Method
    
    private func searchSSAC() {
        homeViewModel.requestSearch(
            params: SearchRequest(
            lat: target.lat,
            long: target.lng))
    }
    
    private func setupMarker(_ queueDB: [FromQueueDB]) {
        for queue in queueDB {
            let coordinate = NMGLatLng(lat: queue.lat, lng: queue.long)
            let marker = NMFMarker()
            marker.position = coordinate
            marker.width = 83
            marker.height = 83
            marker.iconImage = NMFOverlayImage(name: "sesac_face_\(queue.sesac+1)")
            marker.mapView = homeView.mapView
        }
    }
    
    private func setupMatchingButton(_ state: MatchingButton) {
        homeView.matchingButton.setImage(state.image, for: .normal)
        transition(state.pushVC, .push)
    }
}

// MARK: - Naver Map Protocol

extension HomeViewController: NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
    func mapViewCameraIdle(_ mapView: NMFMapView) {
//        searchSSAC()
    }
}

// MARK: - CLLocation Manager Protocol

extension HomeViewController {
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
    
    @frozen
    enum MatchingButton {
        case matching
        case matched
        case normal
        
        var value: Int? {
            switch self {
            case .matching:
                return 1
            case .matched:
                return 0
            case .normal:
                return 0
            }
        }
        
        var image: UIImage? {
            switch self {
            case .matching:
                return Icon.antenna
            case .matched:
                return Icon.message
            case .normal:
                return Icon.search
            }
        }
        
        var pushVC: UIViewController {
            switch self {
            case .matching:
                return NearViewController()
            case .matched:
                return ChatViewController()
            case .normal:
                return SearchViewController()
            }
        }
    }
}
