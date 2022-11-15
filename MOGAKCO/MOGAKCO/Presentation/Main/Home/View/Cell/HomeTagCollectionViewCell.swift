//
//  HomeTagCollectionViewCell.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/16.
//

import UIKit

import SnapKit
import Then

final class HomeTagCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Property
        
    let tagLabel = UILabel().then {
        $0.textColor = Color.black
        $0.font = Font.title4.font
    }
        
    var clickCount: Int = 0 {
        didSet {
            if clickCount == 0 {
                configureUnelectionStyle()
            } else {
                configureSelectionStyle()
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                configureSelectionStyle()
            } else {
                clickCount = 0
                configureUnelectionStyle()
            }
        }
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        layer.cornerRadius = 19
        clipsToBounds = true
        backgroundColor = .white
    }
    
    override func configureLayout() {
        contentView.addSubviews([tagLabel])
        
        tagLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(13)
            make.leading.trailing.equalToSuperview().inset(11)
        }
    }
    
    private func configureSelectionStyle() {
        tagLabel.textColor = .white
        tagLabel.font = Font.title3.font
    }
    
    private func configureUnelectionStyle() {
        tagLabel.textColor = Color.black
        tagLabel.font = Font.title4.font
    }
    
    // MARK: - Set Up Data
    
    func setupData(index: Int) {
//        tagLabel.text = tagData.getTagTitle(index: index)
    }
}
