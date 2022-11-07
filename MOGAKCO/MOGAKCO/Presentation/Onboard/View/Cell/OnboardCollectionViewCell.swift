//
//  OnboardCollectionViewCell.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import UIKit

import SnapKit
import Then

final class OnboardCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Property
    
    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.font = Font.onboard2.font
        $0.lineBreakMode = .byWordWrapping
    }
    
    private let imageView = UIImageView().then {
        $0.image = Icon.onboarding1
        $0.contentMode = .scaleAspectFill
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    // MARK: - UI & Layout
    
    override func configureLayout() {
        contentView.addSubviews([titleLabel,
                                imageView])
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Data
    
    func setupData(_ data: Onboard, _ index: Int) {
        titleLabel.text = data.title
        imageView.image = data.image
        switch index {
        case 0: titleLabel.addProperty(Color.green, font: Font.onboard1.font, "위치 기반으로")
        case 1: titleLabel.addProperty(Color.green, font: Font.onboard1.font, "스터디를 원하는 친구를")
        default:
            titleLabel.addProperty(font: Font.onboard1.font, "SeSAC Study")
            titleLabel.snp.remakeConstraints { make in
                make.top.equalToSuperview().inset(10)
                make.centerX.equalToSuperview()
            }
        }
    }
}
