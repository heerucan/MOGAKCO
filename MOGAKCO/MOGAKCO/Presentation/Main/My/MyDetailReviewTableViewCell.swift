//
//  MyDetailReviewTableViewCell.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/14.
//

import UIKit

final class MyDetailReviewTableViewCell: BaseTableViewCell {

    // MARK: - Property
    
    let titleLabel = UILabel().then {
        $0.textColor = Color.black
        $0.font = Font.title6.font
    }
    
    let reviewLabel = UILabel().then {
        $0.font = Font.body3.font
        $0.text = "첫 리뷰를 기다리는 중이에요!"
        $0.textColor = Color.gray6
    }
    
    let moreButton = UIButton().then {
        $0.setImage(Icon.moreArrow, for: .normal)
    }
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    // MARK: -  UI & Layout
    
    override func configureLayout() {
        contentView.addSubviews([titleLabel, reviewLabel, moreButton])
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(32)
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.directionalHorizontalEdges.equalToSuperview().offset(32)
            make.bottom.equalToSuperview().inset(16)
        }
        
        // MARK: - 이거는 리뷰가 2개 이상이면 노출될 것
        moreButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.trailing.equalToSuperview().inset(32)
        }
    }

    // MARK: - Custom Method
}
