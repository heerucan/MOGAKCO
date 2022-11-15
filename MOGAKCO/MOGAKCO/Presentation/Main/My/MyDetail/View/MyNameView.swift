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
        $0.text = "김새싹"
    }
        
    let moreImageView = UIImageView().then {
        $0.image = Icon.moreDown
    }
        
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }

    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        self.addSubviews([nameLabel, moreImageView])

        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(26)
        }
        
        moreImageView.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.trailing.equalToSuperview()
        }
    }
}
