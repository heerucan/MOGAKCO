//
//  PlainNavigationBar.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/14.
//

import UIKit

import SnapKit
import Then

final class PlainNavigationBar: BaseView {
    
    // MARK: - Enum
    
    @frozen
    enum NavigationType {
        case my
        case myDetail
        case common
        
        fileprivate var title: String {
            switch self {
            case .my: return "내정보"
            case .myDetail: return "정보 관리"
            case .common: return ""
            }
        }
        
        fileprivate var rightButton: UIImage? {
            switch self {
            case .my, .myDetail, .common:
                return nil
            }
        }
        
        fileprivate var rightButtonText: String? {
            switch self {
            case .myDetail: return "저장"
            case .my, .common: return nil
            }
        }
        
        fileprivate var leftButton: UIImage? {
            switch self {
            default: return Icon.arrow
            }
        }
    }
    
    // MARK: - Property
    
    private let titleLabel = UILabel().then {
        $0.font = Font.title3.font
        $0.textColor = Color.black
        $0.textAlignment = .center
    }
    
    private let leftButton = UIButton()
    let rightButton = UIButton()
    
    private let lineView = UIView().then {
        $0.backgroundColor = Color.gray2
    }
    
    var viewController: UIViewController?
    
    private lazy var backAction = UIAction { _ in
        self.viewController?.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Initializer
    
    init(type: NavigationType) {
        super.init(frame: .zero)
        titleLabel.text = type.title
        leftButton.addAction(backAction, for: .touchUpInside)
        leftButton.setImage(type.leftButton, for: .normal)
        rightButton.setImage(type.rightButton, for: .normal)
        rightButton.setTitle(type.rightButtonText, for: .normal)
        rightButton.setTitleColor(Color.black, for: .normal)
        rightButton.titleLabel?.font = Font.title3.font
        rightButton.setTitleColor(Color.gray3, for: .highlighted)
    }

    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        self.addSubviews([leftButton,
                          rightButton,
                          lineView,
                          titleLabel])
        
        leftButton.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(56)
            make.height.equalTo(44)
        }
        
        rightButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(56)
            make.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(11)
            make.centerX.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
