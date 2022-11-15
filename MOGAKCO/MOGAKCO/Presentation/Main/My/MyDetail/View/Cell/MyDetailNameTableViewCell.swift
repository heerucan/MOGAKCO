//
//  MyDetailNameTableViewCell.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/14.
//

import UIKit

import SnapKit
import Then

final class MyDetailNameTableViewCell: BaseTableViewCell {
    
    // MARK: - Property
    
    private lazy var stackView = UIStackView(
        arrangedSubviews: [nameView, titleView, studyView, reviewView]).then {
            $0.makeCornerStyle(width: 1, color: Color.gray2.cgColor, radius: 8)
            $0.axis = .vertical
            $0.spacing = 24
            $0.alignment = .fill
            $0.distribution = .equalSpacing
            $0.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            $0.isLayoutMarginsRelativeArrangement = true
        }
    
    let toggleButton = UIButton()
    
    let nameView = MyNameView()
    
    let titleView = MyTitleView()
    
    let studyView = MyStudyView()
    
    let reviewView = MyReviewView()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16))
    }
    
    // MARK: -  UI & Layout
    
    override func configureLayout() {
        contentView.addSubviews([stackView, toggleButton])
        
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(16).priority(.low)
        }
        
        toggleButton.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(42)
        }
    }
    
    func changeView(isSelected: Bool) {
        if isSelected {
            titleView.isHidden = true
            studyView.isHidden = true
            reviewView.isHidden = true
            nameView.moreImageView.image = Icon.moreDown
        } else {
            titleView.isHidden = false
            studyView.isHidden = false
            reviewView.isHidden = false
            nameView.moreImageView.image = Icon.moreUp
        }
    }
}
