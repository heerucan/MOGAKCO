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
        
    override var isSelected: Bool {
        didSet {
            if isSelected {
                configureSelectionStyle()
            } else {
                configureUnelectionStyle()
            }
        }
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        contentView.addSubviews([tagLabel])
        
        tagLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func configureSelectionStyle() {
        tagLabel.textColor = .white
        tagLabel.font = Font.title3.font
        backgroundColor = Color.green
    }
    
    private func configureUnelectionStyle() {
        tagLabel.textColor = Color.black
        tagLabel.font = Font.title4.font
        backgroundColor = .clear
    }
    
    // MARK: - Set Up Data
    
    func setupData(data: String) {
        tagLabel.text = data
    }
}
