//
//  H48Button.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import UIKit

/**
 PlainButton
 - 기본 버튼 시스템
 */

final class PlainButton: UIButton {
    
    // MARK: - Property
    
    private var height: HeightType = .h48
    var type: PlainButtonType = .fill
    
    var title: String? {
        didSet {
            setTitle(title, for: .normal)
        }
    }
        
    var isEnable: Bool = false {
        didSet {
            configureDisableColor(type: type)
        }
    }
    
    var isSelect: Bool = false {
        didSet {
            configureSelectedColor(type: type)
        }
    }
        
    // MARK: - Initializer
    
    init(_ type: PlainButtonType, height: HeightType) {
        super.init(frame: .zero)
        configureUI(type: type)
        configureLayout(height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func configureUI(type: PlainButtonType) {
        titleLabel?.font = Font.body3.font
        setTitleColor(type.titleColor, for: .normal)
        backgroundColor = type.backgroundColor
        makeCornerStyle(width: type.borderWidth, color: type.borderColor.cgColor, radius: 8)
        setTitleColor(Color.gray4, for: .highlighted)
    }
    
    private func configureLayout(height: HeightType = .h48) {
        snp.makeConstraints { make in
            make.height.equalTo(height.height)
        }
    }
    
    private func configureDisableColor(type: PlainButtonType) {
        let titleColor: UIColor = isEnable ? .white : Color.gray3
        setTitleColor(titleColor, for: .normal)
        backgroundColor = isEnable ? type.backgroundColor : Color.gray6
    }
    
    private func configureSelectedColor(type: PlainButtonType) {
        backgroundColor = isSelect ? type.selectedColor : type.backgroundColor
        setTitleColor(type.selectedTitleColor, for: .selected)
        makeCornerStyle(width: 0, color: type.borderColor.cgColor, radius: 8)
    }
}
