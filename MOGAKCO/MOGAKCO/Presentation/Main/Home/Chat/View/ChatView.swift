//
//  ChatView.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/12/02.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class ChatView: BaseView {

    // MARK: - Property
    
    let alertVC = PlainAlertViewController()
        
    let tapBackground = UITapGestureRecognizer()
    
    lazy var navigationBar = PlainNavigationBar(type: .chat)
    
    let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.showsHorizontalScrollIndicator = false
        $0.separatorStyle = .none
        $0.keyboardDismissMode = .onDrag
        $0.sectionHeaderTopPadding = 0
        $0.allowsSelection = false
        $0.rowHeight = UITableView.automaticDimension
        $0.register(MyChatTableViewCell.self, forCellReuseIdentifier: MyChatTableViewCell.identifier)
        $0.register(YourChatTableViewCell.self, forCellReuseIdentifier: YourChatTableViewCell.identifier)
    }
    
    let chatMoreView = ChatMoreView().then {
        $0.alpha = 0
    }
    
    private lazy var chatDissolveView = UIView().then {
        $0.backgroundColor = Color.black.withAlphaComponent(0.5)
        $0.isHidden = true
        $0.addGestureRecognizer(tapBackground)
    }
    
    lazy var textView = UITextView().then {
        $0.text = Matrix.Placeholder.chat
        $0.textColor = Color.gray7
        $0.font = Font.body3.font
        $0.backgroundColor = Color.gray1
        $0.makeCornerStyle(width: 0, radius: 8)
        $0.textContainerInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 44)
        $0.isScrollEnabled = false
    }
    
    let sendButton = UIButton().then {
        $0.setImage(Icon.sendInactive, for: .normal)
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    // MARK: - UI & Layout1
    
    override func configureLayout() {
        addSubviews([tableView,
                     chatMoreView,
                     navigationBar,
                     textView,
                     sendButton,
                     chatDissolveView])
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalToSuperview()
        }
        
        chatMoreView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(-72)
            make.directionalHorizontalEdges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.textView.snp.top).offset(-16)
        }
        
        textView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-16)
            make.height.greaterThanOrEqualTo(52)
        }
        
        sendButton.snp.makeConstraints { make in
            make.trailing.equalTo(textView.snp.trailing).inset(14)
            make.centerY.equalTo(textView.snp.centerY)
            make.size.equalTo(20)
        }
        
        chatDissolveView.snp.makeConstraints { make in
            make.top.equalTo(chatMoreView.snp.bottom)
            make.directionalHorizontalEdges.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Custom Method
    
    func setupChatMoreView(moreButtonIsSelected value: Bool) {
        navigationBar.rightButton.isSelected.toggle()
        if value == false {
            UIView.animate(withDuration: 0.2) {
                self.chatMoreView.transform = CGAffineTransform(translationX: 0, y: 72)
                self.chatDissolveView.transform = CGAffineTransform(translationX: 0, y: 72)
                self.chatDissolveView.isHidden = false
                self.navigationBar.lineView.alpha = 0
                self.chatMoreView.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.chatMoreView.transform = .identity
                self.chatDissolveView.transform = .identity
                self.chatDissolveView.isHidden = true
                self.navigationBar.lineView.alpha = 1
                self.chatMoreView.alpha = 0
            }
        }
    }
    
    func setupUIByQueueState(_ data: QueueState) {
        if data.matched == 1 {
            alertVC.alertType = .studyCancel
            chatMoreView.cancelButton.setTitle("스터디 취소", for: .normal)
        } else if data.dodged == 1 || data.reviewed == 1 {
            alertVC.alertType = .studyStop
            chatMoreView.cancelButton.setTitle("스터디 종료", for: .normal)
        }
        navigationBar.titleLabel.text = data.matchedNick
    }
    
    func setupSendButton(textFieldText: String) {
        if textFieldText.isEmpty || textView.textColor == Color.gray7 {
            sendButton.setImage(Icon.sendInactive, for: .normal)
        } else {
            sendButton.setImage(Icon.send, for: .normal)
        }
    }
    
    func setupTextViewDidBeginEditing() {
        if textView.textColor == Color.gray7 {
            textView.text = nil
            textView.textColor = Color.black
        }
        textView.snp.remakeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-16)
            make.height.greaterThanOrEqualTo(52)
            make.height.lessThanOrEqualTo(Matrix.Chat.maxHeight)
        }
    }
    
    func setupTextViewDidEndEditing() {
        if textView.text == "" {
            textView.text = Matrix.Placeholder.chat
            textView.textColor = Color.gray7
        }
        textView.snp.remakeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-16)
            make.height.equalTo(52)
        }
    }
    
    func setupTextViewDidChange() {
        if textView.numberOfLine() >= 4 {
            textView.snp.remakeConstraints { make in
                make.directionalHorizontalEdges.equalToSuperview().inset(16)
                make.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-16)
                make.height.equalTo(Matrix.Chat.maxHeight)
            }
            textView.isScrollEnabled = true
        } else {
            textView.snp.remakeConstraints { make in
                make.directionalHorizontalEdges.equalToSuperview().inset(16)
                make.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-16)
                make.height.greaterThanOrEqualTo(52)
                make.height.lessThanOrEqualTo(Matrix.Chat.maxHeight)
            }
            textView.isScrollEnabled = false
        }
    }
}
