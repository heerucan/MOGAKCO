//
//  SesacCollectionViewCell.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/12/29.
//

import UIKit

import SnapKit
import Then

final class SesacCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Property
    
    private let sesacImageView = UIImageView().then {
        $0.makeCornerStyle(width: 1, color: Color.gray2.cgColor, radius: 8)
        $0.clipsToBounds = true
        $0.image = SesacFace.sesac_face_1.image
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [
        sesacImageView, titleLabel, subtitleLabel]).then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.distribution = .equalSpacing
        $0.alignment = .fill
    }
    
    private let titleLabel = UILabel().then {
        $0.font = Font.title2.font
        $0.textColor = Color.black
        $0.text = "기본 새싹"
    }
    
    private let subtitleLabel = UILabel().then {
        $0.font = Font.body3.font
        $0.textColor = Color.black
        $0.numberOfLines = 3
        $0.text = "새싹을 대표하는 기본 식물입니다. 다른 새싹들과 함께 하는 것을 좋아합니다."
    }
    
    private let priceLabel = UILabel().then {
        $0.font = Font.title5.font
        $0.textColor = .white
        $0.backgroundColor = Color.green
        $0.makeCornerStyle(width: 0, radius: 8)
        $0.text = "1,200"
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: - UI & Layout
    
    override func configureUI() {
        super.configureUI()
    }
    
    override func configureLayout() {
        contentView.addSubviews([stackView, priceLabel])
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.directionalHorizontalEdges.bottom.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalTo(stackView.snp.trailing)
            make.width.equalTo(52)
            make.height.equalTo(20)
        }
    }
    
    // MARK: - setupData
    
    func setupData() {
        
    }
}
