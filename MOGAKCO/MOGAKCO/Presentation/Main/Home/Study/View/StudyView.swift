//
//  StudyView.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/19.
//

import UIKit

import SnapKit
import Then

final class StudyView: BaseView {

    // MARK: - Property
    
    let titleLabel = UILabel().then {
        $0.textColor = Color.black
        $0.font = Font.title6.font
    }
    
    let view = UIView().then {
        $0.backgroundColor = .red
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: -  UI & Layout
    
    override func configureLayout() {
        self.addSubviews([titleLabel, view])
        
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
