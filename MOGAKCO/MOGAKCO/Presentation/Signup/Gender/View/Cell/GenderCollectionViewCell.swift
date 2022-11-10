//
//  GenderCollectionViewCell.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/10.
//

import UIKit

import SnapKit
import Then

final class GenderCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Property
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                configureSelectedUI()
            } else {
                configureUI()
            }
        }
    }
    
    private let genderLabel = UILabel().then {
        $0.font = Font.title2.font
        $0.textColor = Color.black
    }
    
    private let genderImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        super.configureUI()
        contentView.makeCornerStyle(width: 1, color: Color.gray3.cgColor, radius: 8)
        contentView.backgroundColor = .white
    }
    
    override func configureLayout() {
        contentView.addSubviews([genderImageView,
                                 genderLabel])
        
        genderImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(14)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(64)
        }
        
        genderLabel.snp.makeConstraints { make in
            make.top.equalTo(genderImageView.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(14)
            make.centerX.equalToSuperview()
        }
    }
    
    private func configureSelectedUI() {
        contentView.backgroundColor = Color.whiteGreen
        contentView.layer.borderWidth = 0
    }
    
    // MARK: - Set Data
    
    func setupData(data: Gender) {
        genderLabel.text = data.text
        genderImageView.image = data.image
    }
}
