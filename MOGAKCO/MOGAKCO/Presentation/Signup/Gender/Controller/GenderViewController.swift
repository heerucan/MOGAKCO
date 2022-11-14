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
                guard let cell = vc.genderView.collectionView.cellForItem(at: indexPath) as? GenderCollectionViewCell
                else { return }
                vc.genderView.reuseView.okButton.isEnable = cell.isSelected ? true : false
                cell.isSelected.toggle()
            }
            .disposed(by: disposeBag)
        
        output.tap
            .withUnretained(self)
            .bind { (vc, gender) in
                if gender.item == 0 {
                    UserDefaultsHelper.standard.gender = 1
                    vc.requestSignup()
                } else {
                    UserDefaultsHelper.standard.gender = 0
                    vc.requestSignup()
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Network
    
    private func requestSignup() {
        let parameters: [String: Any] = [
            "phoneNumber": UserDefaultsHelper.standard.phone ?? "",
            "FCMtoken": APIKey.FCMtoken,
            "nick": UserDefaultsHelper.standard.nickname ?? "",
            "birth": UserDefaultsHelper.standard.birthday ?? "",
            "email": UserDefaultsHelper.standard.email ?? "",
            "gender": UserDefaultsHelper.standard.gender]
        
        APIManager.shared.requestStatusData(type: SignupRequest.self,
                                            method: .post,
                                            url: URL(string: APIKey.baseURL+"/v1/user")!,
                                            parameters: parameters,
                                            headers: ["idtoken": UserDefaultsHelper.standard.idToken!]) { [weak self] response, status in
            guard let self = self else { return }
            switch response {
            case .success(let value):
                print("🟣🟣Sign Response Data ->>> ", value, status as Any)
                self.handle(with: .success)
                let vc = HomeViewController()
                self.transition(vc, .push)
                
            case .failure(let error):
                //TODO: - 여기에 코드를 넣어야 하는지 아니면 handle에 넣어야 하는지
                self.handle(with: error)
                
            case .none:
                break
            }
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
