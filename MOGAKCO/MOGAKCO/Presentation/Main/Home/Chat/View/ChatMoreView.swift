//
//  ChatMoreView.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/12/04.
//

import UIKit

import SnapKit
import Then

final class ChatMoreView: BaseView {
    
    // MARK: - Property

    private lazy var stackView = UIStackView(arrangedSubviews: [reportButton, cancelButton, reviewButton]).then {
        $0.axis = .horizontal
        $0.distribution = .equalCentering
        $0.alignment = .fill
    }
    
    let reportButton = PlainChatButton(.report)
    let cancelButton = PlainChatButton(.cancel)
    let reviewButton = PlainChatButton(.review)
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    // MARK: - UI & Layout

    override func configureLayout() {
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
