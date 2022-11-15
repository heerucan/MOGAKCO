//
//  MyDetailTitleTableViewCell.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/14.
//

import UIKit

final class MyDetailTitleTableViewCell: BaseTableViewCell {

    // MARK: - Property
    
    let titleLabel = UILabel().then {
        $0.textColor = Color.black
        $0.font = Font.title6.font
    }
    
    let view = UIView().then {
        $0.backgroundColor = .red
    }
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    // MARK: -  UI & Layout
    
    override func configureLayout() {
        contentView.addSubviews([titleLabel, view])
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(32)
        }
        
        view.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.directionalHorizontalEdges.equalToSuperview().inset(32)
            make.bottom.equalToSuperview().inset(8)
            make.height.equalTo(112)
        }
    }

    
    // MARK: - Custom Method
}
