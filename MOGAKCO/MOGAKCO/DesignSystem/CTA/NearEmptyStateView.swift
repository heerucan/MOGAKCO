//
//  NearEmptyStateView.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/19.
//

import UIKit

import SnapKit
import Then

final class NearEmptyStateView: BaseView {
    
    @frozen
    enum NearViewType {
        case user
        case request
        
        var title: String {
            switch self {
            case .user:
                return "아쉽게도 주변에 새싹이 없어요ㅠ"
            case .request:
                return "아직 받은 요청이 없어요ㅠ"
            }
        }
    }
    
    // MARK: - Property
    
    let viewType: NearViewType = .user
    
    let imageView = UIImageView().then {
        $0.image = Icon.sprout
    }
    
    let titleLabel = UILabel().then {
        $0.font = Font.display1.font
        $0.textColor = Color.black
    }
    
    let subTitleLabel = UILabel().then {
        $0.text = "스터디를 변경하거나 조금만 더 기다려 주세요!"
        $0.font = Font.title4.font
        $0.textColor = Color.gray7
    }
    
    // MARK: - Initializer
    
    init(type: NearViewType) {
        super.init(frame: .zero)
        titleLabel.text = type.title
    }

    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        self.addSubviews([imageView,
                         titleLabel,
                          subTitleLabel])
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(45)
            make.directionalHorizontalEdges.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Custom Method
}
