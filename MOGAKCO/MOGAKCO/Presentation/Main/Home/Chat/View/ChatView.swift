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
    
    lazy var navigationBar = PlainNavigationBar(type: .chat)
    
    let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .brown
        $0.showsHorizontalScrollIndicator = false
        $0.separatorStyle = .none
        $0.keyboardDismissMode = .onDrag
        $0.sectionHeaderTopPadding = 0
        $0.allowsSelection = false
        $0.rowHeight = UITableView.automaticDimension
        $0.tableHeaderView = ChatHeaderView()
        $0.sectionHeaderHeight = 132
        $0.register(MyChatTableViewCell.self, forCellReuseIdentifier: MyChatTableViewCell.identifier)
        $0.register(YourChatTableViewCell.self, forCellReuseIdentifier: YourChatTableViewCell.identifier)
    }
    
    let chatMoreView = ChatMoreView()
    
    let textView = UITextView().then {
        $0.text = "메세지를 입력하세요"
        $0.textColor = Color.gray7
        $0.font = Font.body3.font
        $0.backgroundColor = Color.gray1
        $0.makeCornerStyle(width: 0, radius: 8)
        $0.contentInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 44)
        $0.isScrollEnabled = false
//        $0.textContainer.maximumNumberOfLines = 3
    }
    
    let sendButton = UIButton().then {
        $0.setImage(Icon.sendInactive, for: .normal)
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupTextView()
    }
    
    // MARK: - UI & Layout
    
    override func configureLayout() {
        addSubviews([tableView, chatMoreView, navigationBar, textView, sendButton])
        
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
            make.bottom.equalTo(self.safeAreaLayoutGuide)
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
    }
    
    func setupTextView() {
        if textView.numberOfLine() >= 4 {
            textView.isScrollEnabled = true
            
        } else {
            textView.isScrollEnabled = false
        }
    }
    
    // MARK: - Custom Method
    
    func adjustTextViewHeight() {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        if newSize.height >= 100 {
            textView.isScrollEnabled = true
        }
        else {
            textView.isScrollEnabled = false
//            textView.snp.updateConstraints { make in
//                make.directionalHorizontalEdges.equalToSuperview().inset(16)
//                make.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-16)
//                make.height.equalTo(newSize.height)
//            }
        }
       layoutSubviews()
    }
}
