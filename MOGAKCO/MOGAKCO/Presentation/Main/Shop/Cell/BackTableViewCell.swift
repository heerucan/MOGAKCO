//
//  BackTableViewCell.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/12/29.
//

import UIKit

import SnapKit
import Then

final class BackTableViewCell: BaseTableViewCell {
    
    // MARK: - Property
    
    private let backImageView = UIImageView().then {
        $0.makeCornerStyle(width: 0, radius: 8)
        $0.clipsToBounds = true
        $0.image = SesacBackground.sesac_background_1.image
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [
        titleLabel, subtitleLabel]).then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    private let titleLabel = UILabel().then {
        $0.font = Font.title3.font
        $0.textColor = Color.black
        $0.text = "하늘 공원"
    }
    
    private let subtitleLabel = UILabel().then {
        $0.font = Font.body3.font
        $0.textColor = Color.black
        $0.numberOfLines = 2
        $0.text = "새싹들을 많이 마주치는 매력적인 하늘 공원입니다"
    }
    
    private let priceLabel = UILabel().then {
        $0.font = Font.title5.font
        $0.textColor = .white
        $0.backgroundColor = Color.green
        $0.makeCornerStyle(width: 0, radius: 8)
        $0.text = "1,200"
    }

    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    // MARK: - UI & Layout
    
    override func configureLayout() {
        addSubviews([backImageView, stackView, priceLabel])
        
        backImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview()
            make.height.width.equalTo(165)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(backImageView.snp.centerY)
            make.leading.equalTo(backImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.top)
            make.trailing.equalTo(stackView.snp.trailing)
            make.width.equalTo(52)
            make.height.equalTo(20)
        }
    }
    
    // MARK: - Set Data
    
//    func setData(data: ) {

//    }
}
