//
//  PlainGenderButton.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/27.
//

import UIKit

/**
 PlainGenderButton
 - 홈 성별 선택 버튼 시스템
 */

final class PlainGenderButton: UIButton {
    
    // MARK: - Property
        
    var title: String? {
        didSet {
            setTitle(title, for: .normal)
        }
    }

    override var isSelected: Bool {
        didSet {
            print(isSelected)
            configureSelectedColor()
        }
    }

    // MARK: - Initializer
    
    init() {
        super.init(frame: .zero)
        configureUI()
        configureLayout()
        configureSelectedColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func configureUI() {
        titleLabel?.font = Font.title4.font
        setTitleColor(Color.black, for: .normal)
        setTitleColor(.white, for: .selected)
        backgroundColor = .white
        makeCornerStyle(width: 0, radius: 8)
    }
    
    private func configureLayout() {
        snp.makeConstraints { make in
            make.width.height.equalTo(48)
        }
    }
    
    private func configureSelectedColor() {
        backgroundColor = isSelected ? Color.green : .white
    }
}
