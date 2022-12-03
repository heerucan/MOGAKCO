//
//  MyDetailInfoTableViewCell.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/14.
//

import UIKit

import MultiSlider
import SnapKit
import Then
import RxSwift

protocol WithdrawDelegate: AnyObject {
    func touchupWithdraw()
}

final class MyDetailInfoTableViewCell: BaseTableViewCell {

    // MARK: - UI Property

    private let genderLabel = UILabel().then {
        $0.text = "내 성별"
    }
    
    let maleButton = PlainButton(.grayLine, height: .h48).then {
        $0.title = "남자"
    }
    
    let femaleButton = PlainButton(.grayLine, height: .h48).then {
        $0.title = "여자"
    }
    
    private let studyLabel = UILabel().then {
        $0.text = "자주 하는 스터디"
    }
    
    private let textField = UITextField().then {
        $0.font = Font.title4.font
        $0.textColor = Color.black
        $0.addPadding(width: 12)
        $0.borderStyle = .none
        $0.placeholder = "스터디를 입력해 주세요"
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = Color.gray3
    }
    
    private let numberLabel = UILabel().then {
        $0.text = "내 번호 검색 허용"
    }
    
    let numberSwitch = UISwitch().then {
        $0.isOn = true
        $0.onTintColor = Color.green
    }
    
    private let ageLabel = UILabel().then {
        $0.text = "상대방 연령대"
    }
    
    let ageSlider = MultiSlider().then {
        $0.orientation = .horizontal
        $0.minimumValue = 18
        $0.maximumValue = 65
        $0.value = [18, 65]
        $0.outerTrackColor = Color.gray2
        $0.tintColor = Color.green
        $0.trackWidth = 4
        $0.showsThumbImageShadow = true
        $0.thumbImage = Icon.filterControl
        $0.keepsDistanceBetweenThumbs = true
        $0.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
    }
    
    private let rangeLabel = UILabel().then {
        $0.font = Font.title3.font
        $0.textColor = Color.green
        $0.text = "18 - 65"
    }
    
    let withdrawButton = UIButton()
    
    private let withdrawLabel = UILabel().then {
        $0.text = "회원탈퇴"
    }
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bindViewModel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    }

    // MARK: - Configure UI & Layout
    
    override func configureUI() {
        super.configureUI()
        configureMenuLabel([genderLabel,
                            studyLabel,
                            numberLabel,
                            ageLabel,
                            withdrawLabel])
    }
    
    override func configureLayout() {
        contentView.addSubviews([genderLabel, maleButton, femaleButton,
                                 studyLabel, textField, lineView,
                                 numberLabel, numberSwitch,
                                 ageLabel, rangeLabel, ageSlider,
                                 withdrawButton, withdrawLabel])
        
        genderLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.leading.equalToSuperview()
        }
        
        maleButton.snp.makeConstraints { make in
            make.centerY.equalTo(genderLabel.snp.centerY)
            make.width.equalTo(56)
            make.trailing.equalTo(femaleButton.snp.leading).offset(-8)
        }
        
        femaleButton.snp.makeConstraints { make in
            make.centerY.equalTo(genderLabel.snp.centerY)
            make.width.equalTo(56)
            make.trailing.equalToSuperview()
        }
        
        studyLabel.snp.makeConstraints { make in
            make.top.equalTo(genderLabel.snp.bottom).offset(42)
            make.leading.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalTo(lineView.snp.leading)
            make.trailing.equalTo(lineView.snp.trailing)
            make.centerY.equalTo(studyLabel.snp.centerY)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(12)
            make.leading.equalTo(studyLabel.snp.trailing).offset(82)
            make.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.top.equalTo(studyLabel.snp.bottom).offset(42)
            make.leading.equalToSuperview()
        }
        
        numberSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(numberLabel.snp.centerY)
            make.trailing.equalToSuperview()
        }
        
        ageLabel.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(42)
            make.leading.equalToSuperview()
        }
        
        rangeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ageLabel.snp.centerY)
            make.trailing.equalToSuperview()
        }
        
        ageSlider.snp.makeConstraints { make in
            make.top.equalTo(ageLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().inset(13)
            make.height.equalTo(28)
        }
        
        withdrawButton.snp.makeConstraints { make in
            make.top.equalTo(ageSlider.snp.bottom)
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalTo(withdrawLabel.snp.bottom).offset(16)
        }
        
        withdrawLabel.snp.makeConstraints { make in
            make.top.equalTo(ageSlider.snp.bottom).offset(29)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().inset(67)
        }
    }

    // MARK: - Custom Method
    
    private func configureMenuLabel(_ label: [UILabel]) {
        label.forEach {
            $0.textColor = Color.black
            $0.font = Font.title4.font
        }
    }
    
    // MARK: - @objc
    
    @objc func sliderChanged(_ sender: MultiSlider) {
        print(sender.minimumValue, sender.maximumValue, sender.value)
        rangeLabel.text = "\(Int(sender.value[0]))" + " - " + "\(Int(sender.value[1]))"
    }
    
    // MARK: - Set Up Data
    
    func setupData(_ data: User) {
        if data.gender == GenderType.female.rawValue {
            femaleButton.isSelect = true
        } else {
            maleButton.isSelect = true
        }
        textField.text = data.study
        numberSwitch.isOn = data.searchable == 1 ? true : false
        rangeLabel.text = "\(data.ageMin)" + " - " + "\(data.ageMax)"
    }
}
