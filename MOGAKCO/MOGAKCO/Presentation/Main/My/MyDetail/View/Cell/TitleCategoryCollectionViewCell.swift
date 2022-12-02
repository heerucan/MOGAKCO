//
//  TitleCategoryCollectionViewCell.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/15.
//

import UIKit

final class TitleCategoryCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Property
    
    let button = PlainButton(.fill, height: .h32)
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func prepareForReuse() {
        button.backgroundColor = .clear
    }
    
    // MARK: - UI & Layout
    
    override func configureLayout() {
        contentView.addSubview(button)

        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - setupData
    
    func setupData(_ data: String, reputation: Int) {
        reputation == 0 ? button.configureUnselected(.grayLine) : button.configureSelected(.fill)
        button.title = data
    }
}
