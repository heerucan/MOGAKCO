//
//  ChatHeaderView.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/12/03.
//

import UIKit

import SnapKit
import Then

final class ChatHeaderView: BaseView {
    
    // MARK: - Property
    
    var name: String = "" {
        didSet {
            matchingLabel.text = name + Matrix.Chat.matching
        }
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [bellImageView, matchingLabel]).then {
        $0.axis = .horizontal
        $0.spacing = 6
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    private let bellImageView = UIImageView().then {
        $0.image = Icon.bell
    }
    
    private let matchingLabel = UILabel().then {
        $0.font = Font.title3.font
        $0.textColor = Color.gray7
        $0.text = "후리방구" + Matrix.Chat.matching
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = Font.title4.font
        $0.textColor = Color.gray6
        $0.textAlignment = .center
        $0.text = Matrix.Chat.description
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    // MARK: - UI & Layout

    override func configureLayout() {
        addSubviews([stackView, descriptionLabel])
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(14)
            make.centerX.equalToSuperview()
        }
        
        bellImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
    }
}
