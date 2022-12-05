//
//  MyChatTableViewCell.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/12/03.
//

import UIKit

final class MyChatTableViewCell: BaseTableViewCell {
    
    // MARK: - Property
    
    private let backView = UIView().then {
        $0.makeCornerStyle(width: 0, radius: 8)
        $0.backgroundColor = Color.whiteGreen
    }
    
    let timeLabel = UILabel().then {
        $0.text = "15:00"
        $0.font = Font.title6.font
        $0.textColor = Color.gray6
    }
    
    let chatLabel = UILabel().then {
        $0.text = "안녕하세요! 저 평일은 저녁 8시에 꾸준히 하는데 7시부터 해도 괜찮아요"
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
            make.trailing.equalToSuperview().inset(16)
            make.width.lessThanOrEqualTo(264)
        }
        
        chatLabel.snp.makeConstraints { make in
            make.directionalVerticalEdges.equalToSuperview().inset(10)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(backView.snp.leading).offset(-8)
            make.bottom.equalTo(backView.snp.bottom)
        }
    }
}
