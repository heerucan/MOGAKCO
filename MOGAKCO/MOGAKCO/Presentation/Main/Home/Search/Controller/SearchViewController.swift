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

final class SearchViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    static let sectionHeaderElementKind = "section-header-element-kind"
    private let searchView = SearchView()
    var searchViewModel: SearchViewModel!
    var homeViewModel: HomeViewModel!
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>!
    private var snapshot: NSDiffableDataSourceSnapshot<Int, String>!
    
    // MARK: - UI Property
    
    private lazy var navigationBar = PlainNavigationBar(type: .search).then {
        $0.viewController = self
    }
    
    private let searchBar = PlainSearchBar()
            
    // MARK: - Init
    
    init(_ viewModel: SearchViewModel, homeViewModel: HomeViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.searchViewModel = viewModel
        self.homeViewModel = homeViewModel
    }
    
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
        searchViewModel.requestSearch(lat: UserDefaultsHelper.standard.lat!, long: UserDefaultsHelper.standard.lng!)
        print(UserDefaultsHelper.standard.lat, UserDefaultsHelper.standard.lng, "좌표다ㅏㅏ@@@@@@@@@@@@@@@@@@@@@@@@@")
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
        
        // TODO: - input/output 적용 + 로직 분리
        
        // 버튼 애니메이션 처리
        searchView.collectionView.rx.contentOffset
            .asDriver()
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.resignResponder()
            }
            .disposed(by: disposeBag)
            
        searchViewModel.searchResponse
            .withUnretained(self)
            .subscribe { (vc, value) in
                vc.searchViewModel.deleteDuplicateStudy(value)
                vc.snapshot = NSDiffableDataSourceSnapshot<Int, String>()
                vc.snapshot.appendSections([0, 1])
                vc.snapshot.appendItems(vc.searchViewModel.nearStudyListRelay.value, toSection: 0)
                vc.snapshot.appendItems(vc.searchViewModel.friendStudyListRelay.value, toSection: 0)
                vc.dataSource?.apply(vc.snapshot)
            }
            .disposed(by: disposeBag)
        
        // 서치바에 내가 작성한 스터디목록 추가 + 띄어쓰기로 분리해서 추가
        searchViewModel.myStudyListRelay
            .withUnretained(self)
            .bind { vc, value in
                if value.count <= 8 {
                    vc.snapshot.appendItems(value, toSection: 1)
                    vc.dataSource.apply(vc.snapshot)
                } else {
                    vc.showToast(Toast.overStudy.message)
                }
            }
            .disposed(by: disposeBag)
        
        // 서치바에 1~8글자 이외인 경우 toast 띄우기
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { vc, value in
                let text = value.components(separatedBy: " ")
                vc.searchViewModel.addMyStudyList(text) { result in
                    vc.showToast(result)
                }
                vc.searchBar.text = "" // 글 입력하고 나서 클리어 시켜주기
            }
            .disposed(by: disposeBag)
        
        // 컬렉션뷰 셀 선택 시에 내가 하고픈 스터디로 추가 및 삭제
        searchView.collectionView.rx.itemSelected
            .withUnretained(self)
            .bind{ vc, indexPath in
                guard let selectedItem = vc.dataSource.itemIdentifier(for: indexPath) else { return }
                switch indexPath.section {
                case 0: // 스터디 추가
                    vc.searchViewModel.myStudyList.append(selectedItem)
                    if vc.searchViewModel.myStudyList.count <= 8 {
                        vc.snapshot.appendItems([selectedItem], toSection: 1)
                        vc.searchViewModel.myStudyListRelay.accept(vc.searchViewModel.myStudyList)
                    } else {
                        vc.searchViewModel.myStudyList.removeLast()
                        vc.showToast(Toast.overStudy.message)
                    }

                default: // 스터디 삭제
                    vc.snapshot.deleteItems([selectedItem])
                    if vc.searchViewModel.nearStudyContains(selectedItem) ||
                        vc.searchViewModel.friendStudyContains(selectedItem) {
                        vc.snapshot.appendItems([selectedItem], toSection: 0)
                    }
                    vc.searchViewModel.myStudyList.remove(at: indexPath.item)
                    vc.searchViewModel.myStudyListRelay.accept(vc.searchViewModel.myStudyList)
                }
                vc.configureDataSource()
                vc.dataSource.apply(vc.snapshot)
            }
            .disposed(by: disposeBag)
        
        // POST - Queue 새싹찾기 서버통신
        searchView.findButton.rx.tap
            .withUnretained(self)
            .bind { vc,_ in
                vc.searchViewModel.requestFindQueue()
            }
            .disposed(by: disposeBag)
        
        searchViewModel.queueResponse
            .withUnretained(self)
            .bind { vc, status in
                if status == 200 {
                    vc.transition(NearViewController(), .push)
                } else if status == 201 {
                    vc.showToast(Toast.overReport.message)
                } else if status == 203 {
                    vc.showToast(Toast.studyCancelFirstPenalty.message)
                } else if status == 204 {
                    vc.showToast(Toast.studyCancelSecondPenalty.message)
                } else if status == 205 {
                    vc.showToast(Toast.studyCancelThirdPenalty.message)
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Custom Method
    
    private func resignResponder() {
        UIView.animate(withDuration: 0.2) {
            self.searchView.findButton.makeCornerStyle(width: 0, radius: 8)
            self.searchView.findButton.snp.updateConstraints { make in
                make.directionalHorizontalEdges.equalToSuperview().inset(16)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - @objc
    
    @objc override func keyboardWillShow(_ notification: NSNotification) {
        super.keyboardWillShow(notification)
        UIView.animate(withDuration: 0.2) {
            let bottomInset = self.keyboardHeight-self.view.safeAreaInsets.bottom
            self.searchView.findButton.snp.updateConstraints { make in
                make.directionalHorizontalEdges.equalToSuperview()
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(bottomInset)
            }
            self.searchView.findButton.makeCornerStyle(width: 0, radius: 0)
            self.view.layoutIfNeeded()
        }
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

            if self.searchViewModel.myStudyContains(itemIdentifier) {
                cell.tagButton.type = .green
            } else if self.searchViewModel.nearStudyContains(itemIdentifier) {
                cell.tagButton.type = .red
            } else {
                cell.tagButton.type = .gray
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

