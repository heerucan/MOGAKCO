//
//  ChatViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/27.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class ChatViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    private let chatView = ChatView()
    var chatViewModel: ChatViewModel!
    private var homeViewModel: HomeViewModel!
    
    // MARK: - UI Property
    
    private let alertVC = PlainAlertViewController()
//    private let reviewVC = ReviewAlertViewController()
        
    // MARK: - Init
    
    init(viewModel: ChatViewModel, homeViewModel: HomeViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.chatViewModel = viewModel
        self.homeViewModel = homeViewModel
    }
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = chatView
    }

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
//        chatViewModel.fetchChat
//        getChatData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SocketIOManager.shared.closeConnection()
    }
    
    // MARK: - UI & Layout
    
    override func configureUI() {
        super.configureUI()
        chatView.navigationBar.viewController = self
    }
    
    override func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getMessage(notification:)),
                                               name: NSNotification.getMessage,
                                               object: nil)
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = ChatViewModel.Input()
        let output = chatViewModel.transform(input)
        
        /// 테이블뷰 세팅
        chatViewModel.chatResponse
            .bind(to: chatView.tableView.rx.items) { [weak self] tableView, row, element in
                if element.from == UserDefaultsHelper.standard.myuid! {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: MyChatTableViewCell.identifier) as? MyChatTableViewCell
                    else { return UITableViewCell() }
                    cell.chatLabel.text = element.chat
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: YourChatTableViewCell.identifier) as? YourChatTableViewCell
                    else { return UITableViewCell() }
                    cell.chatLabel.text = element.chat
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        /// 텍스트뷰 플레이스홀더 처리
        chatView.textView.rx.didBeginEditing
            .withUnretained(self)
            .bind { vc,_ in
                vc.chatView.setupTextViewDidBeginEditing()
            }
            .disposed(by: disposeBag)
        
        chatView.textView.rx.didEndEditing
            .withUnretained(self)
            .bind { vc,_ in
                vc.chatView.setupTextViewDidEndEditing()

            }
            .disposed(by: disposeBag)
        
        chatView.textView.rx.didChange
            .withUnretained(self)
            .bind { vc,_ in
                vc.chatView.setupTextViewDidChange()
            }
            .disposed(by: disposeBag)
        
        /// 텍스트뷰 버튼 처리
        chatView.textView.rx.text
            .orEmpty
            .withUnretained(self)
            .bind { vc, text in
                vc.chatView.setupSendButton(textFieldText: text)
            }
            .disposed(by: disposeBag)
        
        /// navigation Right Bar 처리
        chatView.navigationBar.rightButton.rx.tap
            .withLatestFrom(chatView.navigationBar.rightButton.rx.isSelected)
            .withUnretained(self)
            .bind { vc, value in
                vc.chatView.setupChatMoreView(moreButtonIsSelected: value)
            }
            .disposed(by: disposeBag)
        
        chatView.tapBackground.rx.event
            .withUnretained(self)
            .bind { vc,_ in
                vc.chatView.setupChatMoreView(moreButtonIsSelected: true)
            }
            .disposed(by: disposeBag)
                        
        /// 더보기 버튼 -> queueState 호출
         chatView.navigationBar.rightButton.rx.tap
            .withUnretained(self)
            .bind { vc,_ in
                vc.homeViewModel.requestQueueState()
            }
            .disposed(by: disposeBag)
        
        homeViewModel.queueStateResponse
            .filter { $0.1 == 200 }
            .withUnretained(self)
            .bind { vc, value in
                guard let data = value.0 else { return }
                if data.matched == 1 {
                    vc.alertVC.alertType = .studyCancel
                    vc.chatView.chatMoreView.cancelButton.setTitle("스터디 취소", for: .normal)
                } else if data.dodged == 1 || data.reviewed == 1 {
                    vc.alertVC.alertType = .studyStop
                    vc.chatView.chatMoreView.cancelButton.setTitle("스터디 종료", for: .normal)
                }
            }
            .disposed(by: disposeBag)
        
        /// 스터디 취소 버튼 -> 취소 팝업
        chatView.chatMoreView.cancelButton.rx.tap
            .withUnretained(self)
            .bind { vc,_ in
                vc.alertVC.okButton.addTarget(self, action: #selector(vc.touchupOkButton), for: .touchUpInside)
                vc.transition(vc.alertVC, .alert)
            }
            .disposed(by: disposeBag)
        
        chatViewModel.cancelResponse
            .withUnretained(self)
            .bind { vc, status in
                if status == 200 {
                    vc.navigationController?.popToRootViewController(animated: true)
                } else if status == 201 {
                    print("otheruid 체크해봐라")
                }
            }
            .disposed(by: disposeBag)

        /// 리뷰 등록 버튼 -> 리뷰 팝업 띄워지는 화면으로
        chatView.chatMoreView.reviewButton.rx.tap
            .withUnretained(self)
            .bind { vc,_ in
//                vc.transition(<#T##viewController: T##T#>, .alert)
            }
            .disposed(by: disposeBag)
    
        /// 뒤로가기 버튼 -> 홈으로
        chatView.navigationBar.leftButton.rx.tap
            .withUnretained(self)
            .bind { vc,_ in
                vc.transition(self, .popNavigations, 4)
            }
            .disposed(by: disposeBag)
        
        /// 채팅전송 버튼 -> 채팅전송 POST
        chatView.sendButton.rx.tap
            .withLatestFrom(chatView.textView.rx.text)
            .map { $0 }
            .withUnretained(self)
            .bind { vc, chat in
                print(chat, "==========================채팅")
                guard let chat = chat else { return }
                vc.chatViewModel.postChat(chat, to: vc.chatViewModel.otheruid)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Network
    
    func getChatData() {
        // from - 채팅 상대방 uid
        // lastchatDate - 디바이스에 저장된 마지막 채팅 시간을 전달하는 쿼리 스트링(query string)
//        chatViewModel.requestChatList(from: chatViewModel.otheruid, lastchatDate: <#T##String#>)
    }
    
    // MARK: - @objc
    
    @objc func touchupOkButton() {
        chatViewModel.requestDodge(otheruid: chatViewModel.otheruid)
        print(chatViewModel.otheruid, "스터디 취소 상대방 uid")
    }
    
    @objc func getMessage(notification: NSNotification) {
        
        let chat = notification.userInfo!["chat"] as! String
        let name = notification.userInfo!["name"] as! String
        let createdAt = notification.userInfo!["createdAt"] as! String
        let userID = notification.userInfo!["userId"] as! String
        
        let value = Chat(id: "", to: chatViewModel.otheruid, from: userID, chat: chat, createdAt: createdAt)
        
//        self.chatViewModel.chat.append(value)
//        chatView.tableView.reloadData()
//        chatView.tableView.scrollToRow(at: IndexPath(row: chatViewModel.chat.count - 1, section: 0), at: .bottom, animated: false)
    }
}
