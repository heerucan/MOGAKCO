//
//  MyDetailImageView.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/15.
//

import UIKit

import SnapKit
import Then

final class MyDetailImageView: BaseView {
    
    // MARK: - Property
    
    let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = Icon.sesacBg01
        $0.makeCornerStyle(width: 0, color: .none, radius: 8)
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: -  UI & Layout
    
    override func configureLayout() {
        self.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(343)
            make.height.equalTo(194)
        }
    }
}
