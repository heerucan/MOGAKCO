//
//  MyDetailInfoTableViewCell.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/14.
//

import UIKit

import SnapKit
import Then

enum CellType {
    case gender
    case study
    case number
    case age
    case withdraw
}

final class MyDetailInfoTableViewCell: BaseTableViewCell {
    
    // MARK: - Property
    
    let menuLabel = UILabel().then {
        $0.text = "회원탈퇴"
        $0.textColor = Color.black
        $0.font = Font.title4.font
    }
    
    let maleButton = PlainButton(.fill).then {
        $0.title = "남자"
    }
    
    let femaleButton = PlainButton(.fill).then {
        $0.title = "여자"
    }
    
    let textField = UITextField().then {
        $0.font = Font.title4.font
        $0.textColor = Color.black
        $0.addPadding(width: 12)
        $0.borderStyle = .none
        $0.text = "알고리즘"
    }
    
    let lineView = UIView().then {
        $0.backgroundColor = Color.gray3
    }
    
    let numberSwitch = UISwitch().then {
        $0.isOn = true
        $0.onTintColor = Color.green
    }
    
    let ageSlider = UISlider()
    
    let ageLabel = UILabel().then {
        $0.font = Font.title3.font
        $0.textColor = Color.whiteGreen
    }

    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        contentView.addSubview(menuLabel)
        
        menuLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.directionalVerticalEdges.equalToSuperview().inset(21)
        }
    }
    
    // MARK: - 내 성별
    func configureGender() {
        menuLabel.text = "내 성별"
        contentView.addSubviews([maleButton, femaleButton])
        
        maleButton.snp.makeConstraints { make in
            make.centerY.equalTo(menuLabel.snp.centerY)
            make.width.equalTo(56)
            make.height.equalTo(48)
            make.trailing.equalTo(femaleButton.snp.leading).offset(-8)
        }
        
        femaleButton.snp.makeConstraints { make in
            make.centerY.equalTo(menuLabel.snp.centerY)
            make.width.equalTo(56)
            make.height.equalTo(48)
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - 자주 하는 스터디
    func configureStudy() {
        menuLabel.text = "자주 하는 스터디"
        contentView.addSubviews([textField, lineView])
        
        textField.snp.makeConstraints { make in
            make.leading.equalTo(lineView.snp.leading)
            make.trailing.equalTo(lineView.snp.trailing)
            make.centerY.equalTo(menuLabel.snp.centerY)
        }
        
        lineView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
            make.top.equalTo(textField.snp.bottom).offset(12)
            make.width.equalTo(164)
        }
    }
    
    // MARK: - 내 번호 검색 허용
    func configureNumber() {
        menuLabel.text = "내 번호 검색 허용"
        contentView.addSubview(numberSwitch)
        
        numberSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(menuLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - 연령대
    func configureAge() {
        menuLabel.text = "상대방 연령대"
        contentView.addSubviews([ageLabel, ageSlider])
        
        ageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(menuLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(16)
        }
        
        ageSlider.snp.makeConstraints { make in
            make.top.equalTo(menuLabel.snp.bottom).offset(14)
            make.leading.equalToSuperview().inset(17)
            make.trailing.equalToSuperview().inset(23)
        }
    }
    
    // MARK: - Custom Method

}
