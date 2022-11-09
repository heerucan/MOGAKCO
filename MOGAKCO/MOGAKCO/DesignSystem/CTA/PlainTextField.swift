//
//  PlainTextField.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/09.
//

import UIKit

/**
 LineTextField
 - 밑줄만 있는 텍스트 필드
 */

@frozen
enum TextFieldType {
    case line
    case fill
    
    fileprivate var backgroundColor: UIColor {
        switch self {
        case .line:
            return .white
        case .fill:
            return Color.gray1
        }
    }
    
    fileprivate var font: UIFont {
        switch self {
        case .line:
            return Font.title4.font
        case .fill:
            return Font.body3.font
        }
    }
    
    fileprivate var placeholderColor: UIColor {
        switch self {
        case .line:
            return UIColor(red: 0.533, green: 0.533, blue: 0.533, alpha: 1)
        case .fill:
            return Color.gray7
        }
    }
}

final class PlainTextField: UITextField {
    
    // MARK: - Property
    
    private var type: TextFieldType = .line
    
//    var isFocusing: Bool = false {
//        didSet { setupState() }
//    }
    
    lazy var isDisabled: Bool = false {
        didSet {
            configureDisableColor(type: type)
        }
    }
    
    override var placeholder: String? {
        didSet { setupPlaceholder(type: type) }
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = Color.gray3
    }
    
    // MARK: - Initialize
    
    init(_ type: TextFieldType) {
        super.init(frame: .zero)
        configureUI(type: type)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Method
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let originalRect = super.clearButtonRect(forBounds: bounds)
        return originalRect.offsetBy(dx: -12, dy: 0)
    }
    
    // MARK: - UI & Layout
    
    private func configureUI(type: TextFieldType) {
        font = type.font
        tintColor = Color.black
        layer.cornerRadius = 4
        clearButtonMode = .whileEditing
        setupPadding()
        setupState()
    }
    
    private func configureLayout() {
        addSubview(lineView)
        
        lineView.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom)
            make.directionalHorizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    private func setupPlaceholder(type: TextFieldType) {
        guard let placeholder = placeholder else {
            return
        }

        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: type.placeholderColor]
        )
    }
    
    private func configureDisableColor(type: TextFieldType) {
        isUserInteractionEnabled = isDisabled ? false : true
        backgroundColor = isDisabled ? Color.gray3 : type.backgroundColor
        lineView.backgroundColor = .clear
    }
    
    private func setupPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    private func setupState() {
        self.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        self.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
    }
}

// MARK: - TextField State

extension PlainTextField {
    @objc func editingDidBegin() {
        lineView.backgroundColor = Color.black
    }
    
    @objc func editingDidEnd() {
        lineView.backgroundColor = Color.gray3
    }
}
