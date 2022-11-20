//
//  MyProfileTableViewCell.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/20.
//

import UIKit

import SnapKit
import Then

final class MyProfileTableViewCell: BaseTableViewCell {
    
    // MARK: - Property
    
    let menuImageView = UIImageView().then {
        $0.backgroundColor = .white
        $0.makeCornerStyle(width: 1, color: Color.gray2.cgColor, radius: 48/2)
    }
    
    let menuLabel = UILabel().then {
        $0.textColor = Color.black
        $0.font = Font.title1.font
    }
    
    private let arrowImageView = UIImageView().then {
        $0.image = Icon.moreArrow
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = Color.gray2
    }
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    // MARK: - UI & Layout
    
    override func configureLayout() {
        contentView.addSubviews([arrowImageView,
                                lineView])
        
        arrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(1)
            make.height.equalTo(1)
        }
    }
    
    func configureNameLayout() {
        contentView.addSubviews([menuImageView,
                                 menuLabel])
                
        menuImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.directionalVerticalEdges.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(48)
        }
        
        menuLabel.snp.makeConstraints { make in
            make.directionalVerticalEdges.equalToSuperview().inset(25)
            make.leading.equalTo(menuImageView.snp.trailing).offset(13)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureMenuLayout() {
        contentView.addSubviews([menuImageView,
                                 menuLabel])
        
        menuImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(17)
            make.directionalVerticalEdges.equalToSuperview().inset(25)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        menuLabel.snp.makeConstraints { make in
            make.directionalVerticalEdges.equalToSuperview().inset(24)
            make.leading.equalTo(menuImageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
        
        menuLabel.font = Font.title2.font
        menuImageView.makeCornerStyle(width: 0, radius: 48/2)
    }
    
    // MARK: - Set up Data
    
    func setupData(data: MyProfile) {
        menuLabel.text = data.menu
        menuImageView.image = data.image
        arrowImageView.isHidden = data.arrowIsHidden
    }
}
