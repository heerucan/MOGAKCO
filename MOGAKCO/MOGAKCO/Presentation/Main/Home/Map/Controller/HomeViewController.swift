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
        bindViewModel()
        UserDefaultsHelper.standard.currentUser = true
        print(UserDefaultsHelper.standard.idToken)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function, "뷰윌어피어!!!!!!!!!!!!")
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
        
        // TODO: - 문제는 지금 화면전환 버튼 누르면 -> 화면이 전환되어야 하고
        // TODO: - 내 상태에 따라 버튼이 바껴야 됨
        /// 매칭 버튼 눌렀을 때 화면전환
        homeView.matchingButton.rx.tap
//            .withLatestFrom(homeViewModel.queueStateResponse)
            .withUnretained(self)
            .bind { vc, _ in
//                print(value, "여기")
                vc.pushVC(.normal)
//                guard let data = value.0?.matched else { return }
//                guard let status = value.1 else { return }
//                if data == 0 && status == 200 {
//                    vc.pushVC(.matching)
//                } else if data == 1 && status == 200 {
//                    vc.pushVC(.matched)
//                } else if status == 201 {
//                    vc.pushVC(.normal)
//                }
            }
            .disposed(by: disposeBag)
        
        // 매칭 버튼 값에 따라 버튼 이미지 변경
//        homeViewModel.queueStateResponse
//            .map { $0 }
//            .withUnretained(self)
//            .bind { vc, status in
//                guard let data = status.0?.matched else { return print("이게 문제니?") }
//                guard let status = status.1 else { return }
//                if data == 0 && status == 200 {
//                    vc.setupMatchingButton(.matching)
//                } else if data == 1 && status == 200 {
//                    vc.setupMatchingButton(.matched)
//                } else if status == 201 {
//                    vc.setupMatchingButton(.normal)
//                }
//            }
//            .disposed(by: disposeBag)
    }
    
//    homeView.matchingButton.rx.tap
//        .withUnretained(self)
//        .bind { vc,_ in
//            print(value, "내 현재 상태==========================")
////                vc.homeViewModel.requestQueueState()
////                vc.setupMatchingButton(MatchingButton.normal)
//            /* 일반 상태: 상태 코드가 201 인 경우
//             매칭 대기중 상태: 상태 코드가 200이고, matched 가 0인 경우
//             매칭 상태: 상태 코드가 200이고, matched 가 1인 경우
//             print(value, "매칭버튼 클릭시")
//             */
//            // TODO: - 여기 조금 이상한 문제가 있음.
//            guard let data = value.0?.matched else { return print("이게 문제니?") }
//            guard let status = value.1 else { return }
//            if data == 0 && status == 200 {
//                vc.pushVC(.matching)
//            } else if data == 1 && status == 200 {
//                vc.pushVC(.matched)
//            } else if status == 201 {
//                vc.pushVC(.normal)
//            }
//        }
//        .disposed(by: disposeBag)
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
    
    private func setupMatchingButton(_ state: MatchingButton) {
        homeView.matchingButton.setImage(state.image, for: .normal)
        transition(state.pushVC, .push)
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
    
    @frozen
    enum MatchingButton {
        case matching
        case matched
        case normal
        
        fileprivate var image: UIImage? {
            switch self {
            case .matching:
                return Icon.antenna
            case .matched:
                return Icon.message
            case .normal:
                return Icon.search
            }
        }
        
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
