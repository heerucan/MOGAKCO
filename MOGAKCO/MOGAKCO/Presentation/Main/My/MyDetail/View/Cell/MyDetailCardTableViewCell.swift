//
//  MyDetailCardTableViewCell.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/14.
//

import UIKit

import SnapKit
import Then

final class MyDetailCardTableViewCell: BaseTableViewCell {
    
    // MARK: - Property
    
    let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = Icon.sesacBg01
        $0.makeCornerStyle(width: 0, radius: 8)
    }
    
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
        contentView.addSubviews([profileImageView,
                                 stackView,
                                 toggleButton])
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(16).priority(.low)
        }
        
        toggleButton.snp.makeConstraints { make in
            make.top.equalTo(nameView.snp.top).offset(-16)
            make.leading.equalTo(nameView.snp.leading).offset(-16)
            make.bottom.equalTo(nameView.snp.bottom).offset(16)
            make.trailing.equalTo(nameView.snp.trailing).offset(16)
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
