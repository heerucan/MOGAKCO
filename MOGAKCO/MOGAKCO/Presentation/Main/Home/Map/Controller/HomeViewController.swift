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
    var homeViewModel: HomeViewModel!
        
    // MARK: - Init
    
    init(viewModel: HomeViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.homeViewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel.requestQueueState()
        bindViewModel()
        UserDefaultsHelper.standard.currentUser = true
        print(UserDefaultsHelper.standard.idToken)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeViewModel.requestQueueState()
        homeViewModel.searchAroundFriend(
            lat: LocationManager.coordinate().latitude,
            lng: LocationManager.coordinate().longitude)
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
                print(coordinate, "💟 homeViewModel.locationSubject💟 ")
                vc.homeView.mapView.latitude = coordinate.latitude
                vc.homeView.mapView.longitude = coordinate.longitude
            }
            .disposed(by: disposeBag)
        
        LocationManager.shared.rx.didUpdateLocations
            .compactMap { $0.last?.coordinate }
            .withUnretained(self)
            .subscribe { vc, coordinate in
                print(coordinate, "didUpdateLocations💟 ")
                vc.homeViewModel.searchAroundFriend(lat: coordinate.latitude, lng: coordinate.longitude)
                vc.homeViewModel.locationSubject.onNext(coordinate)
                vc.homeView.mapView.moveCamera(vc.homeViewModel.updateCurrentLocation())
            }
            .disposed(by: disposeBag)
        
        LocationManager.shared.rx.didFailWithError
            .withUnretained(self)
            .subscribe(onNext: { vc, error in
                print(error, "💟 didFailWithError💟 ")
                vc.homeViewModel.checkUserAuthorization(LocationManager.shared.authorizationStatus) { status in
                    vc.showLocationServiceAlert()
                }
            })
            .disposed(by: disposeBag)
        
        LocationManager.shared.rx.didChangeAuthorizationStatus
            .withUnretained(self)
            .subscribe(onNext: { vc, status in
                print(status, "💟 didChangeAuthorizationStatus💟 ")
                if CLLocationManager.locationServicesEnabled() {
                    vc.homeViewModel.searchAroundFriend(
                        lat: LocationManager.coordinate().latitude,
                        lng: LocationManager.coordinate().longitude)
//                    print("지도 위치 받아서 주변 새싹 찾기")
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
                    print(search.fromQueueDB.count, search.fromQueueDBRequested.count)
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
        
        /// 내 위치 버튼
        output.locationTap
            .withUnretained(self)
            .bind { vc,_ in
                LocationManager.shared.startUpdatingLocation()
                vc.homeView.mapView.moveCamera(vc.homeViewModel.updateCurrentLocation())
            }
            .disposed(by: disposeBag)

        // 매칭 버튼 값에 따라 버튼 이미지 변경
        homeViewModel.queueStateResponse
            .withUnretained(self)
            .bind { vc, value in
                if value == 0 {
                    vc.homeView.matchingButton.setImage(Icon.antenna, for: .normal)
                } else if value == 1 {
                    vc.homeView.matchingButton.setImage(Icon.message, for: .normal)
                } else if value == 201 {
                    vc.homeView.matchingButton.setImage(Icon.search, for: .normal)
                }
            }
            .disposed(by: disposeBag)
        
        homeView.matchingButton.rx.tap
            .withLatestFrom(homeViewModel.queueStateResponse)
            .withUnretained(self)
            .bind { vc, value in
                if value == 0 {
                    vc.pushVC(.matching)
                } else if value == 1 {
                    vc.pushVC(.matched)
                } else if value == 201 {
                    vc.pushVC(.normal)
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Custom Method
    
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

    private func pushVC(_ state: MatchingButton) {
        transition(state.pushVC, .push)
    }
}

// MARK: - Naver Map Protocol

extension HomeViewController: NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        print(mapView.latitude, mapView.longitude, "카메라 이동 함수, 좌표")
        homeViewModel.searchAroundFriend(lat: mapView.latitude, lng: mapView.longitude)
        UserDefaultsHelper.standard.lat = mapView.latitude
        UserDefaultsHelper.standard.lng = mapView.longitude
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
}

extension HomeViewController {
    @frozen
    enum MatchingButton {
        case matching
        case matched
        case normal
        
        fileprivate var pushVC: UIViewController {
            switch self {
            case .matching:
                return NearViewController()
            case .matched:
                return ChatViewController(viewModel: ChatViewModel())
            case .normal:
                return SearchViewController(homeViewModel: HomeViewModel(), searchViewModel: SearchViewModel())
            }
        }
    }
}
