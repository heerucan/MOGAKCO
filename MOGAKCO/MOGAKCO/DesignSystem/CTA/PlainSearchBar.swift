//
//  PlainSearchBar.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/21.
//

import UIKit

final class PlainSearchBar: UISearchBar {
    
    // MARK: - Property
    
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func configureUI() {
        clipsToBounds = true
        tintColor = Color.black
        backgroundColor = Color.gray1
        backgroundImage = UIImage()
        searchTextField.backgroundColor = Color.gray1
        searchTextField.textColor = Color.black
        searchTextField.font = Font.title4.font
        makeCornerStyle(width: 0, color: nil, radius: 10)
        let attributedString = NSMutableAttributedString(
            string: "띄어쓰기로 복수 입력이 가능해요",
            attributes: [.foregroundColor: Color.gray6,
                         .font: Font.title4.font])
        searchTextField.attributedPlaceholder = attributedString
//        searchTextField.leftView = .none
    }
    
    // MARK: - Custom Method
    
}
