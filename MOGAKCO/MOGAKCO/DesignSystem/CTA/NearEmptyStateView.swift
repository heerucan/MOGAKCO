//
//  NearEmptyStateView.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/19.
//

import UIKit

import SnapKit
import Then

// MARK: - Enum

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

final class NearEmptyStateView: BaseView {
    
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
    
    private lazy var stackView = UIStackView(arrangedSubviews: [changeButton, refreshButton]).then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    let changeButton = PlainButton(.fill, height: .h48).then {
        $0.title = "스터디 변경하기"
    }
    
    let refreshButton = PlainButton(.outline, height: .h48).then {
        $0.setImage(Icon.refresh, for: .normal)
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
                          subTitleLabel,
                          stackView])
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(187)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(45)
            make.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.directionalHorizontalEdges.equalToSuperview().inset(48)
        }
        
        stackView.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(16)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.width.equalTo(48)
        }
    }
    
    // MARK: - Custom Method
}
