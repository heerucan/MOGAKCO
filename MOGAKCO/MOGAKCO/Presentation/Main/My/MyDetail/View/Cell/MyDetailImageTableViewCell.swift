//
//  MyDetailImageTableViewCell.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/14.
//

import UIKit

import SnapKit
import Then

final class MyDetailImageTableViewCell: BaseTableViewCell {

    // MARK: - Property
    
    let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = Icon.sesacBg01
        $0.makeCornerStyle(width: 0, color: .none, radius: 8)
    }
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    // MARK: -  UI & Layout
    
    override func configureLayout() {
        contentView.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.width.equalTo(343)
            make.height.equalTo(194)
        }
    }
}
