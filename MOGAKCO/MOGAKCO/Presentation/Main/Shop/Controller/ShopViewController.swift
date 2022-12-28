//
//  ShopViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/13.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class ShopViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    private let shopViewModel = ShopViewModel()
    
    private lazy var navigationBar = PlainNavigationBar(type: .shop).then {
        $0.viewController = self
    }
    
    private let saveButton = PlainRequestButton().then {
        $0.type = .save
    }
    
    private let profileImageView = UIImageView().then {
        $0.image = SesacBackground.sesac_background_1.image
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.makeCornerStyle(width: 0, radius: 8)
    }
    
    private let ssacImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = SesacFace.sesac_face_1.image
    }
    
    private let segmentedControl = PlainSegmentedControl(items: [Matrix.Shop.sesac, Matrix.Shop.background]).then {
        $0.selectedSegmentIndex = 0
        $0.addTarget(self, action: #selector(changeValue(sender:)), for: .valueChanged)
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = Color.green
    }
    
    private lazy var sesacCollectionView = UICollectionView(frame: .zero, collectionViewLayout: sesacLayout)
    
    private lazy var backTableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.alpha = 0.0
    }
    
    private let sesacLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: Matrix.Shop.width, height: Matrix.Shop.height)
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical
        return layout
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    // MARK: - UI & Layout
    
    override func configureUI() {
        super.configureUI()
        sesacCollectionView.delegate = self
        sesacCollectionView.dataSource = self
        sesacCollectionView.register(SesacCollectionViewCell.self, forCellWithReuseIdentifier: SesacCollectionViewCell.identifier)
        backTableView.delegate = self
        backTableView.dataSource = self
        backTableView.register(BackTableViewCell.self, forCellReuseIdentifier: BackTableViewCell.identifier)
    }
    
    override func configureLayout() {
        view.addSubviews([navigationBar,
                          segmentedControl,
                          lineView,
                          profileImageView,
                          sesacCollectionView,
                          backTableView,
                          saveButton])
        profileImageView.addSubviews([ssacImageView])
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.layoutMarginsGuide)
            make.directionalHorizontalEdges.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(194)
        }
        
        ssacImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(10)
            make.width.height.equalTo(184)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).inset(12)
            make.trailing.equalTo(profileImageView.snp.trailing).inset(12)
            make.width.equalTo(80)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom)
            make.directionalHorizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(-2)
            make.leading.equalToSuperview()
            make.height.equalTo(2)
            make.width.equalTo(view.frame.width/2)
        }
        
        sesacCollectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(12)
            make.directionalHorizontalEdges.bottom.equalToSuperview().inset(16)
        }
        
        backTableView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(12)
            make.directionalHorizontalEdges.bottom.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        saveButton.rx.tap
            .withUnretained(self)
            .bind { vc,_ in
                vc.shopViewModel.requestSave()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Custom Method
    
    private func changeLinePosition() {
        let segmentIndex = CGFloat(segmentedControl.selectedSegmentIndex)
        let segmentWidth = segmentedControl.frame.width / 2
        let leadingDistance = segmentWidth * segmentIndex
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.lineView.transform = CGAffineTransform(translationX: leadingDistance, y: 0)
        })
    }
    
    // MARK: - @objc
    
    @objc private func changeValue(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            sesacCollectionView.alpha = 1.0
            backTableView.alpha = 0.0
        } else {
            sesacCollectionView.alpha = 0.0
            backTableView.alpha = 1.0
        }
        changeLinePosition()
    }
}

extension ShopViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BackTableViewCell.identifier, for: indexPath) as? BackTableViewCell else { return UITableViewCell() }
        return cell
    }
}

extension ShopViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SesacCollectionViewCell.identifier, for: indexPath) as? SesacCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
}
