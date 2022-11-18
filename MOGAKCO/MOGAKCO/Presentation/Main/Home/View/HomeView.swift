//
//  HomeView.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/14.
//

import UIKit

import SnapKit
import Then
import NMapsMap

final class HomeView: BaseView {
    
    // MARK: - Property
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.backgroundColor = .white
        $0.makeShadow(color: Color.black.cgColor, radius: 3, offset: CGSize(width: 0, height: 1), opacity: 0.3)
        $0.makeCornerStyle(width: 0, radius: 8)
        $0.register(HomeTagCollectionViewCell.self, forCellWithReuseIdentifier: HomeTagCollectionViewCell.identifier)
    }
    
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 48, height: 48)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        layout.scrollDirection = .vertical
        return layout
    }()
        
    lazy var mapView = NMFMapView(frame: self.frame).then {
        $0.minZoomLevel = 9
        $0.maxZoomLevel = 16
        $0.positionMode = .compass
        $0.locationOverlay.hidden = false
//        $0.locationOverlay.circleColor = Color.green.withAlphaComponent(5)
    }
    
    let locationButton = UIButton().then {
        $0.backgroundColor = .white
        $0.imageView?.image?.withTintColor(.white)
        $0.setImage(Icon.place, for: .normal)
        $0.makeCornerStyle(width: 0, radius: 8)
        $0.makeShadow(color: Color.black.cgColor, radius: 3, offset: CGSize(width: 0, height: 1), opacity: 0.3)
    }
    
    let matchingButton = UIButton().then {
        $0.setImage(Icon.search, for: .normal)
        $0.makeCornerStyle(width: 0, radius: 64/2)
        $0.backgroundColor = Color.black
        $0.makeShadow(color: Color.black.cgColor, radius: 3, offset: CGSize(width: 0, height: 1), opacity: 0.3)
    }
    
    let markerImageView = UIImageView().then {
        $0.image = Icon.mapMarker
    }
        
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }

    // MARK: - UI & Layout
    
   override func configureLayout() {
       self.addSubviews([mapView,
                         collectionView,
                         locationButton,
                         matchingButton,
                         markerImageView])
       
       mapView.snp.makeConstraints { make in
           make.top.leading.trailing.equalToSuperview()
           make.bottom.equalTo(self.layoutMarginsGuide)
       }
       
       collectionView.snp.makeConstraints { make in
           make.top.equalToSuperview().inset(52)
           make.leading.equalToSuperview().inset(16)
           make.width.equalTo(48)
           make.height.equalTo(144)
       }
       
       locationButton.snp.makeConstraints { make in
           make.top.equalTo(collectionView.snp.bottom).offset(16)
           make.leading.equalToSuperview().inset(16)
           make.width.height.equalTo(48)
       }
       
       matchingButton.snp.makeConstraints { make in
           make.bottom.trailing.equalToSuperview().inset(16)
           make.width.height.equalTo(64)
       }
       
       markerImageView.snp.makeConstraints { make in
           make.center.equalTo(mapView)
       }
    }
    
    func setupMapDelegate(_ touchDelegate: NMFMapViewTouchDelegate,
                          _ cameraDelegate: NMFMapViewCameraDelegate) {
        mapView.touchDelegate = touchDelegate
        mapView.addCameraDelegate(delegate: cameraDelegate)
    }
    
    // MARK: - Custom Method
}
