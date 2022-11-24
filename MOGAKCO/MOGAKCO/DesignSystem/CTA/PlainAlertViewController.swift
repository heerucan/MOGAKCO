//
//  PlainAlertViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/21.
//

import UIKit

import SnapKit
import Then

/**
 PlainAlertViewController
 - 알림 팝업 뷰컨
 */

// MARK: - Delegate

protocol OkButtonDelegate: AnyObject {
    func touchupOkButton()
}

final class PlainAlertViewController: BaseViewController {
    
    // MARK: - Property
    
    weak var okButtonDelegate: OkButtonDelegate?
    
    var alertType: AlertType = .withdraw {
        didSet {
            titleLabel.text = alertType.title
            subtitleLabel.text = alertType.subtitle
        }
    }
        
    private let backView = UIView().then {
        $0.backgroundColor = .white
        $0.makeCornerStyle(width: 0, radius: 16)
    }
    
    private let titleLabel = UILabel().then {
        $0.font = Font.body1.font
        $0.textColor = Color.black
        $0.textAlignment = .center
    }
    
    private let subtitleLabel = UILabel().then {
        $0.font = Font.title4.font
        $0.textColor = Color.gray7
        $0.textAlignment = .center
    }
    
    private lazy var buttonStackView = UIStackView(arrangedSubviews: [cancelButton, okButton]).then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    private lazy var cancelButton = PlainButton(.cancel, height: .h48).then {
        $0.title = "취소"
        $0.addAction(cancelAction, for: .touchUpInside)
    }
    
    private lazy var okButton = PlainButton(.fill, height: .h48).then {
        $0.title = "확인"
        $0.addAction(okAction, for: .touchUpInside)
    }
    
    private lazy var cancelAction = UIAction { _ in
        self.dismiss(animated: false)
    }
    
    private lazy var okAction = UIAction { _ in
        self.dismiss(animated: false) {
            self.okButtonDelegate?.touchupOkButton()
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut) { [weak self] in
            guard let self = self else { return }
            self.view.backgroundColor = Color.black.withAlphaComponent(0.5)
        }
    }

    // MARK: - UI & Layout
    
    override func configureUI() {
        view.backgroundColor = Color.black.withAlphaComponent(0)
    }
    
    override func configureLayout() {
        view.addSubview(backView)
        backView.addSubviews([titleLabel, subtitleLabel, buttonStackView])
        
        backView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(22)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(16)
            make.leading.bottom.trailing.equalToSuperview().inset(16)
        }
    }
}
