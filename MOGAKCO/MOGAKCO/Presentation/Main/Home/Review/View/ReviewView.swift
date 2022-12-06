//
//  ReviewView.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/12/06.
//

import UIKit

import SnapKit
import Then

final class ReviewView: BaseView {

    // MARK: - Property
    
    weak var okButtonDelegate: OkButtonDelegate?
    
    var name: String = "" {
        didSet {
            subtitleLabel.text = name + AlertType.review.subtitle
        }
    }
    
    private let backView = UIView().then {
        $0.backgroundColor = .white
        $0.makeCornerStyle(width: 0, radius: 20)
    }
    
    private let titleLabel = UILabel().then {
        $0.text = AlertType.review.title
        $0.font = Font.title3.font
        $0.textColor = Color.black
        $0.textAlignment = .center
    }
    
    private lazy var subtitleLabel = UILabel().then {
        $0.text = name + AlertType.review.subtitle
        $0.font = Font.title4.font
        $0.textColor = Color.green
        $0.textAlignment = .center
    }
    
    private lazy var buttonStackView = UIStackView(arrangedSubviews: [leftButtonStackView, rightButtonStackView]).then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    private lazy var leftButtonStackView = UIStackView(arrangedSubviews: [mannerButton, fastButton, abilityButton]).then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    private lazy var rightButtonStackView = UIStackView(arrangedSubviews: [timeButton, niceButton, usefulbutton]).then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    private lazy var closeButton = UIButton().then {
        $0.setImage(Icon.closeBig, for: .normal)
        $0.addAction(closeAction, for: .touchUpInside)
    }
    
    let mannerButton = PlainButton(.grayLine, height: .h32).then {
        $0.title = "좋은 매너"
    }
    
    let timeButton = PlainButton(.grayLine, height: .h32).then {
        $0.title = "정확한 시간 약속"
    }
    
    let fastButton = PlainButton(.grayLine, height: .h32).then {
        $0.title = "빠른 응답"
    }
    
    let niceButton = PlainButton(.grayLine, height: .h32).then {
        $0.title = "친절한 성격"
    }
    
    let abilityButton = PlainButton(.grayLine, height: .h32).then {
        $0.title = "능숙한 실력"
    }
    
    let usefulbutton = PlainButton(.grayLine, height: .h32).then {
        $0.title = "유익한 시간"
    }
    
    let textView = UITextView().then {
        $0.text = Matrix.Placeholder.review
        $0.textColor = Color.gray7
        $0.font = Font.body3.font
        $0.makeCornerStyle(width: 0, radius: 8)
        $0.backgroundColor = Color.gray1
        $0.textContainerInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
    }
    
    lazy var okButton = PlainButton(.fill, height: .h48).then {
        $0.title = "리뷰 등록하기"
        $0.addAction(okAction, for: .touchUpInside)
    }
    
    private lazy var closeAction = UIAction { _ in
//        self.dismiss(animated: false)
    }
    
    private lazy var okAction = UIAction { _ in
        self.okButtonDelegate?.touchupOkButton()
//        self.dismiss(animated: false)
    }
    
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    // MARK: - UI & Layout
 
    override func configureLayout() {
        addSubview(backView)
        backView.addSubviews([titleLabel, subtitleLabel, closeButton, buttonStackView, textView, okButton])
        
        backView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.directionalVerticalEdges.equalToSuperview().inset(181)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(17)
            make.height.equalTo(22)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(17)
            make.centerX.equalToSuperview()
            make.height.equalTo(22)
        }
        
        closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(16)
        }
        
//        leftButtonStackView.snp.makeConstraints { make in
//            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
//            make.leading.equalToSuperview().inset(16)
//        }
//
//        rightButtonStackView.snp.makeConstraints { make in
//            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
//            make.trailing.equalToSuperview().inset(16)
//        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(leftButtonStackView.snp.bottom).offset(24)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(124)
        }
        
        okButton.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(24)
            make.directionalHorizontalEdges.bottom.equalToSuperview().inset(16)
        }
    }
}
