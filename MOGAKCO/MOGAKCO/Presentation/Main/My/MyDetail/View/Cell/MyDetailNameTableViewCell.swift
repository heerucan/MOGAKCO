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
    
    lazy var borderStackView = UIStackView(arrangedSubviews: [nameView,
                                                              titleView,
                                                              studyView,
                                                              reviewView]).then {
        $0.backgroundColor = .blue
        $0.makeCornerStyle(width: 1, color: Color.gray2.cgColor, radius: 8)
        $0.axis = .vertical
        $0.spacing = 24
        $0.alignment = .fill
        $0.distribution = .equalSpacing
    }
      
    let nameView = MyNameView()
    
    let titleView = MyTitleView()
    
    let studyView = MyStudyView()
    
    let reviewView = MyReviewView()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        nameView.backgroundColor = .orange
        titleView.backgroundColor = .red
        reviewView.backgroundColor = .yellow
        studyView.backgroundColor = .green
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16))
        contentView.makeCornerStyle(width: 1, color: Color.gray2.cgColor, radius: 8)
    }
    
    // MARK: -  UI & Layout
    
    override func configureLayout() {
        contentView.addSubviews([nameView,
                                 titleView,
                                 studyView,
                                 reviewView])
//
//        borderStackView.snp.makeConstraints { make in
//            make.top.leading.trailing.equalToSuperview()
//            make.bottom.equalToSuperview().offset(16)
//        }

//        nameLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview().inset(16)
////            make.bottom.equalToSuperview().inset(16)
//            make.leading.equalToSuperview()
//            make.trailing.equalTo(toggleButton.snp.trailing).inset(20)
//        }
//
//        nameLabel.snp.makeConstraints { make in
//            make.directionalVerticalEdges.equalToSuperview().inset(16)
//        }
        
        nameView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.height.equalTo(26+16)
        }
        
        titleView.snp.makeConstraints { make in
            make.top.equalTo(nameView.snp.bottom).offset(8)
        }
        
        studyView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(24)
        }
        
        reviewView.snp.makeConstraints { make in
            make.top.equalTo(studyView.snp.bottom).offset(24)
            make.bottom.equalToSuperview().offset(-32).priority(.low)
        }
    
        
        // MARK: - 여기를 안해줘서 안됐던 것임
        
//        reviewView.snp.makeConstraints { make in
//            make.bottom.equalToSuperview()
//        }

        [nameView, titleView, studyView, reviewView].forEach {
            $0.snp.makeConstraints { make in
                make.directionalHorizontalEdges.equalToSuperview().inset(16)
            }
        }
    }
}
