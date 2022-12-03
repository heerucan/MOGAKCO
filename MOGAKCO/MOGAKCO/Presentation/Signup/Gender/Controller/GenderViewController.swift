//
//  GenderViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/09.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class GenderViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    private let gender = GenderData()
    private let genderView = GenderView()
    private let genderViewModel = GenderViewModel()
    private var dataSource: UICollectionViewDiffableDataSource<Int, Gender>?
    
    // MARK: - UI Property
    
    private lazy var navigationBar = PlainNavigationBar(type: .common).then {
        $0.viewController = self
    }
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = genderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        bindViewModel()
    }
    
    // MARK: - UI & Layout
        
    override func configureLayout() {
        view.addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.layoutMarginsGuide)
            make.directionalHorizontalEdges.equalToSuperview()
        }
    }
    
    override func setupDelegate() {
        genderView.setupDelegate(self)
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = GenderViewModel.Input(genderIndex: genderView.collectionView.rx.itemSelected, tap: genderView.reuseView.okButton.rx.tap)
        let output = genderViewModel.transform(input)
        
        output.gender
            .withUnretained(self)
            .subscribe { (vc, value) in
                var snapshot = NSDiffableDataSourceSnapshot<Int, Gender>()
                snapshot.appendSections([0])
                snapshot.appendItems(value, toSection: 0)
                vc.dataSource?.apply(snapshot)
            }
            .disposed(by: disposeBag)
        
        output.genderIndex
            .withUnretained(self)
            .bind { (vc, indexPath) in
                guard let cell = vc.genderView.collectionView.cellForItem(at: indexPath)
                        as? GenderCollectionViewCell
                else { return }
                vc.genderView.reuseView.okButton.isEnable = cell.isSelected ? true : false
                cell.isSelected.toggle()
            }
            .disposed(by: disposeBag)
        
        output.tap
            .withUnretained(self)
            .bind { (vc, gender) in
                if gender.item == 0 {
                    UserDefaultsHelper.standard.gender = GenderType.male.rawValue
                } else {
                    UserDefaultsHelper.standard.gender = GenderType.female.rawValue
                }
                vc.genderViewModel.requestSignup()
            }
            .disposed(by: disposeBag)
        
        output.response
            .withUnretained(self)
            .subscribe { vc, response in
                vc.pushVC(status: response.0)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Custom Method
    
    private func pushVC(status: Int?) {
        guard let status = status else { return }
        switch status {
        case 200:
            let tabVC = TabBarController()
            transition(tabVC, .push)
            
        case 201:
            showToast(Toast.currentUser.message)
            
        case 202:
            transition(self, .popNavigations, 4)
            showToast(Toast.invalidNickname.message)
        
        default:  break
        }
    }
}

// MARK: - Configure DataSource / UICollectionViewDelegate

extension GenderViewController: UICollectionViewDelegate {
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<GenderCollectionViewCell, Gender> { cell, indexPath, itemIdentifier in
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: genderView.collectionView,
                                                        cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration, for: indexPath, item: itemIdentifier)
            cell.setupData(data: itemIdentifier)
            return cell
        })
    }
}
