//
//  MyNameView.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/15.
//

import UIKit

import SnapKit
import Then

final class MyNameView: BaseView {
    
    // MARK: - Property
    
    let nameLabel = UILabel().then {
        $0.textColor = Color.black
        $0.font = Font.title1.font
    }
        
    let toggleButton = UIButton().then {
        $0.setImage(Icon.moreDown, for: .normal)
    }
    
    let touchfulButton = UIButton()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }

    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        self.addSubviews([nameLabel, toggleButton])
        
        toggleButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        toggleButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
    }
}
