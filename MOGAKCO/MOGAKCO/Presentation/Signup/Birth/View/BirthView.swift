//
//  BirthView.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/10.
//

import UIKit

import SnapKit
import Then

final class BirthView: BaseView {
    
    // MARK: - Property
    
    let reuseView = AuthReuseView(Matrix.birthTitle).then {
        $0.buttonTitle = Matrix.nextButtonTitle
        $0.okButton.isEnable = false
        $0.topInset = 185
    }
    
    lazy var datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 216)).then {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .wheels
        $0.locale = Locale(identifier: "ko-KR")
        $0.becomeFirstResponder()
    }
    
    lazy var stackView = UIStackView(arrangedSubviews: [yearStackView, monthStackView, dayStackView]).then {
        $0.spacing = 23
        $0.distribution = .fillEqually
    }
    
    lazy var yearStackView = UIStackView(arrangedSubviews: [yearTextField, yearLabel]).then {
        $0.spacing = 4
        $0.distribution = .fillProportionally
        $0.axis = .horizontal
    }
    
    lazy var yearTextField = PlainTextField(.line).then {
        $0.placeholder = "1990"
    }
    
    let yearLabel = UILabel().then {
        $0.text = "년"
    }
    
    lazy var monthStackView = UIStackView(arrangedSubviews: [monthTextField, monthLabel]).then {
        $0.spacing = 4
        $0.distribution = .fillProportionally
        $0.axis = .horizontal
    }
    
    lazy var monthTextField = PlainTextField(.line).then {
        $0.placeholder = "1"
    }
    
    let monthLabel = UILabel().then {
        $0.text = "월"
    }
    
    lazy var dayStackView = UIStackView(arrangedSubviews: [dayTextField, dayLabel]).then {
        $0.spacing = 4
        $0.distribution = .fillProportionally
        $0.axis = .horizontal
    }
    
    lazy var dayTextField = PlainTextField(.line).then {
        $0.placeholder = "1"
    }
    
    let dayLabel = UILabel().then {
        $0.text = "일"
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    // MARK: - UI & Layout
    
    override func configureUI() {
        super.configureUI()
        [yearTextField, monthTextField, dayTextField].forEach {
            $0.inputView = datePicker
            $0.clearButtonMode = .never
            $0.tintColor = .clear
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            $0.font = Font.title2.font
            $0.textColor = Color.black
        }
    }
    
    override func configureLayout() {
        addSubviews([reuseView,
                     stackView])
        
        reuseView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(297)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        [yearTextField, monthTextField, dayTextField].forEach {
            $0.snp.makeConstraints { make in
                make.width.equalTo(80)
            }
        }
    }
    
    func setupDelegate(_ delegate: UITextFieldDelegate) {
        yearTextField.delegate = delegate
        monthTextField.delegate = delegate
        dayTextField.delegate = delegate
    }
}
