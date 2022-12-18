//
//  MyTitleView.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/15.
//

import UIKit

import SnapKit
import Then
import RxSwift

final class MyTitleView: BaseView {
    
    // MARK: - DisposeBag
    
    let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    var titleData: [Int] = [0, 0, 0, 0, 0, 0] // 타이틀뷰의 버튼의 isSelected를 받는 배열
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>?
    
    private lazy var titleStackView = UIStackView(
        arrangedSubviews: [titleLabel, titleCollectionView]).then {
            $0.axis = .vertical
            $0.spacing = 16
            $0.alignment = .fill
        }
    
    private let titleLabel = UILabel().then {
        $0.textColor = Color.black
        $0.font = Font.title6.font
        $0.text = "새싹 타이틀"
    }
    
    lazy var titleCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureDataSource()
        bindViewModel()
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        self.addSubviews([titleStackView])
        
        titleStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
        
        titleCollectionView.snp.makeConstraints { make in
            make.height.equalTo(112)
        }
    }
    
    override func setupDelegate() {
        titleCollectionView.delegate = self
        titleCollectionView.register(TitleCategoryCollectionViewCell.self, forCellWithReuseIdentifier: TitleCategoryCollectionViewCell.identifier)
    }
    
    override func bindViewModel() {
        Observable.of(["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 실력", "유익한 시간"])
            .withUnretained(self)
            .subscribe { (vc, value) in
                var snapShot = NSDiffableDataSourceSnapshot<Int, String>()
                snapShot.appendSections([0])
                snapShot.appendItems(value, toSection: 0)
                self.dataSource?.apply(snapShot)
            }
            .disposed(by: disposeBag)
        
        titleCollectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                    print("왕", indexPath)
                
                })
                .disposed(by: disposeBag)
    }
}

// MARK: - CollectionView Layout

extension MyTitleView: UICollectionViewDelegate {
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let spacing = 8.0
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(32))
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: 2)
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(spacing)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            return section
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        let layout = createCompositionalLayout()
        layout.configuration = configuration
        layout.configuration.scrollDirection = .horizontal
        return layout
    }
}

// MARK: - Configure DataSource / UICollectionViewDelegate

extension MyTitleView {
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TitleCategoryCollectionViewCell, String> { cell, indexPath, itemIdentifier in
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: titleCollectionView,
                                                        cellProvider: { [self] collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration, for: indexPath, item: itemIdentifier)
            cell.setupData(itemIdentifier, reputation: self.titleData[indexPath.item])
            cell.button.isEnabled = false
            return cell
        })
        
//        var snapShot = NSDiffableDataSourceSnapshot<Int, String>()
//        snapShot.appendSections([0])
//        snapShot.appendItems(["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 실력", "유익한 시간"], toSection: 0)
//        dataSource?.apply(snapShot)
    }
}
