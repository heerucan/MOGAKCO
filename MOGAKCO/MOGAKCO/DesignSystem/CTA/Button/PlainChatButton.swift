//
//  PlainChatButton.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/12/04.
//

import UIKit

/**
 PlainChatButton
 - 채팅 상단 더보기 누르면 나오는 버튼
 */

final class PlainChatButton: UIButton {
    
    // MARK: - Enum

    enum ChatButtonType {
        case report
        case cancel
        case review
        
        fileprivate var buttonText: String {
            switch self {
            case .report:
                return "새싹 신고"
            case .cancel:
                return "스터디 취소"
            case .review:
                return "리뷰 등록"
            }
        }
        
        fileprivate var buttonImage: UIImage? {
            switch self {
            case .report:
                return Icon.siren
            case .cancel:
                return Icon.cancelMatch
            case .review:
                return Icon.write
            }
        }
    }
    
    // MARK: - Property
    
    var type: ChatButtonType = .report {
        didSet {
            configureUI(type: type)
        }
    }
 
    // MARK: - Initializer
    
    init(_ type: ChatButtonType) {
        super.init(frame: .zero)
        configureUI(type: type)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func configureUI(type: ChatButtonType) {
        backgroundColor = .white
        setTitle(type.buttonText, for: .normal)
        setTitleColor(Color.black, for: .normal)
        titleLabel?.font = Font.title3.font
        var configuration = PlainChatButton.Configuration.plain()
        configuration.titleAlignment = .center
        configuration.image = type.buttonImage
        configuration.imagePlacement = .top
        configuration.imagePadding = 4
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 11, leading: 0, bottom: 11, trailing: 0)
        self.configuration = configuration
    }
    
    private func configureLayout() {
        snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width/3)
            make.height.equalTo(72)
        }
    }
}
