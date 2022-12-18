//
//  YourChatTableViewCell.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/12/03.
//

import UIKit

import SnapKit
import Then

final class YourChatTableViewCell: BaseTableViewCell {
    
    // MARK: - Property
    
    private let backView = UIView().then {
        $0.makeCornerStyle(width: 1, color: Color.gray4.cgColor, radius: 8)
        $0.backgroundColor = .white
    }
    
    private let timeLabel = UILabel().then {
        $0.font = Font.title6.font
        $0.textColor = Color.gray6
    }
    
    private let chatLabel = UILabel().then {
        $0.font = Font.body3.font
        $0.textColor = Color.black
        $0.numberOfLines = 0
    }
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    // MARK: - UI & Layout
    
    override func configureLayout() {
        addSubviews([backView, timeLabel])
        backView.addSubview(chatLabel)
        
        backView.snp.makeConstraints { make in
            make.directionalVerticalEdges.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(16)
            make.width.lessThanOrEqualTo(264)
        }
        
        chatLabel.snp.makeConstraints { make in
            make.directionalVerticalEdges.equalToSuperview().inset(10)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(backView.snp.trailing).offset(8)
            make.bottom.equalTo(backView.snp.bottom)
        }
    }
    
    // MARK: - Set Data
    
    func setData(data: Chat) {
        chatLabel.text = data.chat
        timeLabel.text = data.createdAt
    }
}
