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
    
    override func setupDelegate() {
        genderView.setupDelegate(self)
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = GenderViewModel.Input(genderTap: genderView.reuseView.okButton.rx.tap)
        let output = genderViewModel.transform(input)
        
        output.gender // output
            .withUnretained(self)
            .subscribe { (vc, value) in
                var snapshot = NSDiffableDataSourceSnapshot<Int, Gender>()
                snapshot.appendSections([0])
                snapshot.appendItems(value, toSection: 0)
                vc.dataSource?.apply(snapshot)
            }
            .disposed(by: disposeBag)
        
        genderView.collectionView.rx.itemSelected
            .withUnretained(self)
            .bind { (vc, indexPath) in
                guard let cell = vc.genderView.collectionView.cellForItem(at: indexPath) as? GenderCollectionViewCell
                else { return }
                vc.genderView.reuseView.okButton.isEnable = cell.isSelected ? true : false
                cell.isSelected.toggle()
            }
            .disposed(by: disposeBag)
        
        output.genderTap
            .withUnretained(self)
            .bind { (vc,_) in
//                vc.pushHomeView()
                print("홈으로 이동!!")
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Custom Method
    
    private func pushHomeView() {
        let viewController = NicknameViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UITextField Delegate

extension GenderViewController: UITextFieldDelegate, UICollectionViewDelegate { }

// MARK: - Configure DataSource

extension GenderViewController {
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
