//
//  PlainAlertViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/21.
//

import UIKit

import SnapKit
import Then

// MARK: - Enum

@frozen
enum AlertType {
    case withdraw
    case studyRequest
    case studyAccept
    case studyCancel
    case addFriend
    
    var title: String {
        switch self {
        case .withdraw:
            return "정말 탈퇴하시겠습니까?"
        case .studyRequest:
            return "스터디를 요청할게요!"
        case .studyAccept:
            return "스터디를 수락할까요?"
        case .studyCancel:
            return "스터디를 취소하겠습니까?"
        case .addFriend:
            return "고래밥님을 친구 목록에 추가할까요?"
        }
    }
    
    var subtitle: String {
        switch self {
        case .withdraw:
            return "탈퇴하시면 새싹 스터디를 이용할 수 없어요ㅠ"
        case .studyRequest:
            return "요청이 수락되면 30분 후에 리뷰를 남길 수 있어요"
        case .studyAccept:
            return "요청을 수락하면 채팅창에서 대화를 나눌 수 있어요"
        case .studyCancel:
            return "스터디를 취소하시면 패널티가 부과됩니다"
        case .addFriend:
            return "친구 목록에 추가하면 언제든지 채팅을 할 수 있어요"
        }
    }
}

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
