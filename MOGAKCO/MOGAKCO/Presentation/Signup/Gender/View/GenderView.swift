//
//  GenderView.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/09.
//

import UIKit

import SnapKit
import Then

final class GenderView: BaseView {
    
    // MARK: - Property
    
    let reuseView = AuthReuseView(Matrix.genderTitle, subtitle: Matrix.genderSubtitle).then {
        $0.buttonTitle = Matrix.nextButtonTitle
        $0.okButton.isEnabled = false
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    // MARK: - UI & Layout
    
    override func configureLayout() {
        addSubviews([reuseView,
                     collectionView])
        
        reuseView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(266)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(15)
            make.height.equalTo(120)
        }
    }
    
    func setupDelegate(_ delegate: UICollectionViewDelegate) {
        collectionView.delegate = delegate
    }
}

// MARK: - CollectionView Layout

extension GenderView {
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(120))
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: 2)
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(12)
            
            let section = NSCollectionLayoutSection(group: group)
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
