//
//  DetailTableViewCell.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/24.
//

import UIKit

import SnapKit
import Then

final class DetailTableViewCell: BaseTableViewCell {

    // MARK: - Property
    
    let reviewLabel = UILabel().then {
        $0.font = Font.body3.font
        $0.textColor = Color.black
    }
    
    let lineView = UIView().then {
        $0.backgroundColor = Color.gray2
    }
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    // MARK: - UI & Layout

    override func configureLayout() {
        contentView.addSubviews([reviewLabel, lineView])
        
        reviewLabel.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom).offset(16)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(1)
            make.height.equalTo(1)
        }
    }
    
    // MARK: - Custom Method
    
    func setupData(data: String) {
        reviewLabel.text = data
    }
}
