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
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 48, height: 48)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
//        layout.sectionInset = UIEdgeInsets(top: 2, left: Matrix.cellMargin, bottom: 2, right: Matrix.cellMargin)
        layout.scrollDirection = .vertical
        return layout
    }()
        
    lazy var mapView = NMFMapView(frame: self.frame).then {
        $0.minZoomLevel = 9
        $0.maxZoomLevel = 16
        $0.positionMode = .compass
        $0.locationOverlay.hidden = true
    }
    
    let locationButton = UIButton().then {
        $0.backgroundColor = .white
        $0.setImage(Icon.place, for: .normal)
        $0.makeCornerStyle(width: 0, color: UIColor.clear.cgColor, radius: 8)
        $0.makeShadow(radius: 11, offset: CGSize(width: 0, height: 0), opacity: 0.25)
    }
    
    let matchingButton = UIButton().then {
        $0.setImage(Icon.search, for: .normal)
        $0.makeCornerStyle(width: 0, color: UIColor.clear.cgColor, radius: 64/2)
        $0.backgroundColor = Color.black
    }
        
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }

    // MARK: - UI & Layout
    
   override func configureLayout() {
       self.addSubviews([mapView, locationButton, matchingButton, collectionView])
       
       mapView.snp.makeConstraints { make in
           make.top.leading.trailing.equalToSuperview()
           make.bottom.equalTo(self.layoutMarginsGuide)
       }
       
       collectionView.snp.makeConstraints { make in
           make.top.equalToSuperview().inset(52)
           make.leading.equalToSuperview().inset(16)
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
    }
    
    func setupMapDelegate(_ touchDelegate: NMFMapViewTouchDelegate,
                          _ cameraDelegate: NMFMapViewCameraDelegate) {
        mapView.touchDelegate = touchDelegate
        mapView.addCameraDelegate(delegate: cameraDelegate)
    }
    
    func setupCollectionViewDelegate(_ delegate: UICollectionViewDelegate,
                                     _ dataSource: UICollectionViewDataSource) {
        collectionView.backgroundColor = .white
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
        collectionView.register(
            HomeTagCollectionViewCell.self,
            forCellWithReuseIdentifier: HomeTagCollectionViewCell.identifier)
    }
    
    // MARK: - Custom Method
}
