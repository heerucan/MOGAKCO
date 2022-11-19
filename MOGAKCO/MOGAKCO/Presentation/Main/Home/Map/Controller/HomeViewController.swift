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
        homeViewModel.requestQueueState()
        searchSSAC()
    }
    
    // MARK: - UI & Layout
    
    override func setupDelegate() {
        homeView.setupMapDelegate(self, self)
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = HomeViewModel.Input(locationTap: homeView.locationButton.rx.tap, itemSelected: homeView.collectionView.rx.itemSelected)
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
//                vc.searchSSAC()
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
        
        //        LocationManager.shared.startUpdatingLocation()
        
        output.tagList
            .bind(to: homeView.collectionView.rx.items(
                cellIdentifier: HomeTagCollectionViewCell.identifier,
                cellType: HomeTagCollectionViewCell.self)) { index, item, cell in
                    cell.setupData(data: item)
                }
                .disposed(by: disposeBag)
        
        output.itemSelected
            .withUnretained(self)
            .bind { vc, indexPath in
                print(indexPath)
                indexPath.item
                // TODO: - 선택 시마다 gender filtering
                vc.searchSSAC()
            }
            .disposed(by: disposeBag)
        
        
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
        
        output.searchResponse
            .withUnretained(self)
            .subscribe { vc, response in
                guard let search = response.0 else { return }
                vc.handle(with: .success)
                vc.setupMarker(0, search.fromQueueDB)
                vc.setupMarker(0, search.fromQueueDBRequested)
            } onError: { [weak self] error in
                guard let self = self else { return }
                self.handle(with: error as! APIError)
            }
            .disposed(by: disposeBag)
        
        output.queueStateResponse
            .withUnretained(self)
            .subscribe { vc, response in
                guard let state = response.0 else { return }
                guard let status = response.1 else { return }
                // TODO: - 리팩토링 요망
                if status == 201 {
                    vc.homeView.matchingButton.setImage(Icon.search, for: .normal)
//                    vc.transition(SearchViewController(), .push)
                } else if status == 200 && state.matched == 0 {
                    vc.homeView.matchingButton.setImage(Icon.antenna, for: .normal)
//                    vc.transition(SearchViewController(), .push)
                } else {
                    vc.homeView.matchingButton.setImage(Icon.message, for: .normal)
//                    vc.transition(SearchViewController(), .push)
                }
            } onError: { [weak self] error in
                guard let self = self else { return }
                self.handle(with: error as! APIError)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Custom Method
    
    private func searchSSAC() {
        // MARK: - 이부분 고쳐야 함 -> SearchRequest(lat: target.lat, long: target.lng)
        let target = self.homeView.mapView.cameraPosition.target
        homeViewModel.requestSearch(params: SearchRequest(lat: Matrix.ssacLat, long: Matrix.ssacLong))
    }
    
    private func setupMarker(_ gender: Int? = 0, _ queueDB: [FromQueueDB]) {
        for queue in queueDB {
            if queue.gender == gender {
                let coordinate = NMGLatLng(lat: queue.lat, lng: queue.long)
                let marker = NMFMarker()
                marker.position = coordinate
                marker.width = 83
                marker.height = 83
                marker.iconImage = NMFOverlayImage(name: "sesac_face_\(queue.sesac-1)")
                marker.mapView = homeView.mapView
            }
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
