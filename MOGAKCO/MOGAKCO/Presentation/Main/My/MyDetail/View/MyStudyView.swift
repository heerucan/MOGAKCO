//
//  MyStudyView.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/15.
//

import UIKit

import SnapKit
import Then

final class MyStudyView: BaseView {
    
    // MARK: - Property
    
    var studyData: [String] = [] {
        didSet {
//            print(oldValue, "스터디데이터")
            configureDataSource()
        }
    }
    
    private var snapShot: NSDiffableDataSourceSnapshot<Int, String>!
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>!

    private let studyLabel = UILabel().then {
        $0.textColor = Color.black
        $0.font = Font.title6.font
        $0.text = "하고 싶은 스터디"
    }

    private lazy var studyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureDataSource()
    }

    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        self.addSubviews([studyLabel, studyCollectionView])

        studyLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalTo(18)
        }
        
        // TODO: - 동적 높이 해결
        studyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(studyLabel.snp.bottom).offset(16)
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    // MARK: - Custom Method
    
    override func setupDelegate() {
        studyCollectionView.delegate = self
        studyCollectionView.register(SearchCollectionViewCell.self,
                                     forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
    }
}

// MARK: - CollectionView Layout

extension MyStudyView: UICollectionViewDelegate {
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .estimated(58),
                heightDimension: .estimated(32))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(32))
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item])
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(8)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
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

extension MyStudyView {
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SearchCollectionViewCell, String> { cell, indexPath, itemIdentifier in
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: studyCollectionView,
                                                        cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration, for: indexPath, item: itemIdentifier)
            cell.tagButton.type = .gray
            cell.setupData(data: itemIdentifier)
            return cell
        })
        
        var snapShot = NSDiffableDataSourceSnapshot<Int, String>()
        snapShot.appendSections([0])
        snapShot.appendItems(Array(Set(studyData)), toSection: 0)
        dataSource?.apply(snapShot)
    }
}
