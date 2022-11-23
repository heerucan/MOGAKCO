//
//  SearchViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/19.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class SearchViewController: BaseViewController, OkButtonDelegate {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    //    enum Section: Int {
    //        case near = 0, want
    //        func description() -> String {
    //            switch self {
    //            case .near:
    //                return "지금 주변에는 "
    //            case .want:
    //                return "내가 하고 싶은"
    //            }
    //        }
    //    }
    
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    private let searchView = SearchView()
    private let searchViewModel = SearchViewModel()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>!
    var snapshot: NSDiffableDataSourceSnapshot<Int, String>!
    
    // MARK: - UI Property
    
    private lazy var navigationBar = PlainNavigationBar(type: .search).then {
        $0.viewController = self
    }
    
    private let searchBar = PlainSearchBar()
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - UI & Layout
    
    override func configureLayout() {
        view.addSubviews([navigationBar, searchBar])
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.leftButton.snp.top).offset(4)
            make.bottom.equalTo(navigationBar.leftButton.snp.bottom).offset(-4)
            make.leading.equalTo(navigationBar.leftButton.snp.trailing).offset(-8)
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    override func setupDelegate() {
        searchView.setupDelegate(self)
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = SearchViewModel.Input()
        let output = searchViewModel.transform(input)
        
        searchViewModel.searchResponse
            .withUnretained(self)
            .subscribe { (vc, value) in
                vc.snapshot = NSDiffableDataSourceSnapshot<Int, String>()
                vc.snapshot.appendSections([0, 1])
                vc.snapshot.appendItems(value, toSection: 0)
                vc.snapshot.appendItems(["안녕내친구들의 스터디", "외오애ㅐ오"], toSection: 0)
                vc.snapshot.appendItems(["두 번째", "섹션", "최악"], toSection: 1)
                vc.dataSource?.apply(vc.snapshot)
            }
            .disposed(by: disposeBag)
        
        searchView.collectionView.rx.contentOffset
            .asDriver()
            .drive { [weak self] _ in
                self?.searchView.findButton.transform = .identity
            }
            .disposed(by: disposeBag)

    }
    
    // MARK: - Custom Method
    
    func touchupOkButton() {
        let vc = SearchViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - @objc
    
    @objc override func keyboardWillShow(_ notification: NSNotification) {
        super.keyboardWillShow(notification)
        UIView.animate(withDuration: 0.1) {
            self.searchView.findButton.transform = CGAffineTransform(translationX: 0, y: 32-(self.keyboardHeight))
        }
    }
    
    @objc func touchupRequestButton(_ sender: UIButton) {
        let vc = PlainAlertViewController()
        vc.alertType = .studyAccept
        vc.okButtonDelegate = self
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false)
    }
}

// MARK: - Configure DataSource / UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SearchCollectionViewCell, String> { cell, indexPath, itemIdentifier in
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: searchView.collectionView,
                                                        cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration, for: indexPath, item: itemIdentifier)
            cell.setupData(data: itemIdentifier)
            if indexPath.section == 0 {
                if indexPath.item > 2 {
                    cell.tagButton.layer.borderColor = Color.gray2.cgColor
                }
            } else {
                cell.tagButton.layer.borderColor = Color.green.cgColor
            }
                
            return cell
        })
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration
        <SearchHeaderSupplementaryView>(elementKind: UICollectionView.elementKindSectionHeader) {
            (supplementaryView, string, indexPath) in
            let snapshot = ["지금 주변에는", "내가 하고 싶은"]
            supplementaryView.sectionLabel.text = snapshot[indexPath.section]
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.searchView.collectionView.dequeueConfiguredReusableSupplementary(
                using: supplementaryRegistration, for: index)
        }
    }
}

