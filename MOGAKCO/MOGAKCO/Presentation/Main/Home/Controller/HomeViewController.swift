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
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        UserDefaultsHelper.standard.currentUser = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkUserMatchingState()
        searchSSAC()
    }
    
    // MARK: - UI & Layout
    
    override func configureUI() {
        super.configureUI()
        navigationController?.isNavigationBarHidden = true
    }
    
    override func setupDelegate() {
        homeView.setupMapDelegate(self, self)
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = HomeViewModel.Input(locationTap: homeView.locationButton.rx.tap)
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
                vc.searchSSAC()
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
        
        LocationManager.shared.rx.didUpdateLocations
            .compactMap { $0.last?.coordinate } // 1차원 배열에서 nil 제거, 옵셔널 바인딩
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
                print("😡 사용자의 위치를 가져오지 못했습니다.", error)
                vc.homeViewModel.checkUserAuthorization(LocationManager.shared.authorizationStatus) { status in
                   vc.showLocationServiceAlert()
                }
            })
            .disposed(by: disposeBag)
        
        // MARK: - 서버통신 코드 넣기
        LocationManager.shared.rx.didChangeAuthorizationStatus
            .withUnretained(self)
            .subscribe(onNext: { vc, status in
                if CLLocationManager.locationServicesEnabled() {
                    vc.homeViewModel.checkUserAuthorization(status) { status in
                        status == .denied || status == .restricted ? vc.showLocationServiceAlert() : vc.searchSSAC()
                    }
                } else {
                    vc.showLocationServiceAlert()
                }
            })
            .disposed(by: disposeBag)
        
        LocationManager.shared.startUpdatingLocation()
        
        // MARK: - 서버통신
        
        output.locationTap
            .compactMap { $0 }
            .withUnretained(self)
            .bind { vc, coordinate in
                LocationManager.shared.startUpdatingLocation()
                // TODO: - 여기 서버통신 데이터 붙이고 나서 고쳐야 함, 임의로 영등포로 해둠
                let target = self.homeView.mapView.cameraPosition.target
                vc.homeViewModel.updateCurrentLocation(CLLocationCoordinate2D(latitude: Matrix.ssacLat, longitude: Matrix.ssacLong)) { cameraUpdate in
                    vc.homeView.mapView.moveCamera(cameraUpdate)
                }
            }
            .disposed(by: disposeBag)
        
        // MARK: - 어노테이션 꽂기
        
        homeViewModel.searchResponse
            .withUnretained(self)
            .subscribe { vc, response in
                vc.handle(with: .success)
                response.fromQueueDB + response.fromQueueDBRequested
                vc.setupMarker(response.fromQueueDB)
                
            } onError: { [weak self] error in
                guard let self = self else { return }
                self.handle(with: error as! APIError)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - 유저의 현재 매칭 상태 확인
    
    private func checkUserMatchingState() {
        homeViewModel.requestQueueState()
        homeViewModel.queueStateResponse
            .withUnretained(self)
            .subscribe { vc, state in
                if state.matched == 1 {
                    vc.homeView.matchingButton.setImage(Icon.search, for: .normal)
                } else if state.matched == 0 {
                    vc.homeView.matchingButton.setImage(Icon.antenna, for: .normal)
                } else {
                    vc.homeView.matchingButton.setImage(Icon.message, for: .normal)
                }
            } onError: { [weak self] error in
                guard let self = self else { return }
                self.handle(with: error as! APIError)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - 현재 지도 중심 좌표 기준으로 새싹 찾기
    
    private func searchSSAC() {
        // MARK: - 이부분 고쳐야 함 -> SearchRequest(lat: target.lat, long: target.lng)
        let target = self.homeView.mapView.cameraPosition.target
        homeViewModel.requestSearch(params: SearchRequest(lat: Matrix.ssacLat, long: Matrix.ssacLong))
    }
    
    // MARK: - 새싹 마커 꽂기
    
    private func setupMarker(_ fromQueueDB: [FromQueueDB]) {
        for queue in fromQueueDB {
            print(queue)
            let coordinate = NMGLatLng(lat: queue.lat, lng: queue.long)
            let marker = NMFMarker()
            marker.position = coordinate
            marker.iconImage = NMFOverlayImage(name: Icon.sesac_face_1)
            marker.mapView = homeView.mapView
        }
    }
}

// MARK: - Naver Map Protocol

extension HomeViewController: NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        searchSSAC()
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            print("카메라 대기 이벤트")
        }
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
