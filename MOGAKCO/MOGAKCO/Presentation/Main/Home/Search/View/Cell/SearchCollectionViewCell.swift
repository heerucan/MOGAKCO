//
//  SearchCollectionViewCell.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/20.
//

import UIKit

final class SearchCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Property
    
    let view = UIView()
    let tagButton = PlainTagButton(.red)
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    // MARK: - UI & Layout
    
    override func configureLayout() {
        contentView.addSubviews([tagButton, view])
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tagButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Custom Method
    
    func setupData(data: String) {
        tagButton.setTitle(data, for: .normal)
    }
}
