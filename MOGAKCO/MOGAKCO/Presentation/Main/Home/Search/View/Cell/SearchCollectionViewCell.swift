//
//  SearchCollectionViewCell.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/20.
//

import UIKit

final class SearchCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Property
    
    let tagButton = PlainButton(.redOutline, height: .h32).then {
        $0.title = "안녕하세요"
        var config = PlainButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16)
        $0.configuration = config
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    // MARK: - UI & Layout
    
    override func configureLayout() {
        contentView.addSubview(tagButton)
        
        tagButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Custom Method
    
    func setupData(data: String) {
        tagButton.setTitle(data, for: .normal)
    }
}
