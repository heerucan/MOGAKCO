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
                
    // MARK: - Init
    
    init(_ viewModel: ChatViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.chatViewModel = viewModel
    }
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = chatView
    }

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        chatViewModel.requestQueueState()
        
        // from : 상대방 uid / lastchatDate : 마지막 채팅 시간
        chatViewModel.fetchChat(from: chatViewModel.matchedArray[1],
                                lastchatDate: "2022-12-18T09:37:05.625Z") { dataCount in
            self.moveToBottom(dataCount)
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getMessage(notification:)),
                                               name: NSNotification.getMessage,
                                               object: nil)
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
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = ChatViewModel.Input()
        let output = chatViewModel.transform(input)
            
        /// 테이블뷰 세팅
        // TODO: - 채팅 시간 HH:mm 처리해줘야 됨
        chatViewModel.chatResponse
            .bind(to: chatView.tableView.rx.items) { tableView, row, element in
                if element.from == self.chatViewModel.matchedArray[1] {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: YourChatTableViewCell.identifier) as? YourChatTableViewCell
                    else { return UITableViewCell() }
                    cell.setData(data: element)
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: MyChatTableViewCell.identifier) as? MyChatTableViewCell
                    else { return UITableViewCell() }
                    cell.setData(data: element)
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        chatView.tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
                
        /// 텍스트뷰 플레이스홀더 처리
        chatView.textView.rx.didBeginEditing
            .withUnretained(self)
            .bind { vc,_ in
                vc.chatView.setupTextViewDidBeginEditing()
                vc.moveToBottom(vc.chatViewModel.chatList.count-1)
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
                vc.chatViewModel.requestQueueState()
            }
            .disposed(by: disposeBag)
        
        chatViewModel.queueStateResponse
            .withUnretained(self)
            .bind { vc, data in
                vc.chatView.setupUIByQueueState(data)
            }
            .disposed(by: disposeBag)
        
        /// 스터디 취소 버튼 -> 취소 팝업
        chatView.chatMoreView.cancelButton.rx.tap
            .withUnretained(self)
            .bind { vc,_ in
                vc.chatView.alertVC.okButton.addTarget(self, action: #selector(vc.touchupOkButton), for: .touchUpInside)
                vc.transition(vc.chatView.alertVC, .alert)
            }
            .disposed(by: disposeBag)
        
        chatViewModel.cancelResponse
            .withUnretained(self)
            .bind { vc, status in
                if status == 200 {
                    vc.navigationController?.popToRootViewController(animated: true)
                } else if status == 201 {
                    print("otheruid 체크")
                }
            }
            .disposed(by: disposeBag)

        /// 리뷰 등록 버튼 -> 리뷰 팝업 띄워지는 화면으로
        chatView.chatMoreView.reviewButton.rx.tap
            .withUnretained(self)
            .bind { vc,_ in
                let reviewVC = ReviewViewController(ReviewViewModel())
                reviewVC.reviewViewModel.matchedArray = vc.chatViewModel.matchedArray
                vc.transition(reviewVC, .alert)
            }
            .disposed(by: disposeBag)
    
        /// 뒤로가기 버튼 -> 홈으로
        chatView.navigationBar.leftButton.rx.tap
            .withUnretained(self)
            .bind { vc,_ in
                vc.navigationController?.popToRootViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        /// 채팅전송 버튼 -> 채팅전송 POST
        chatView.sendButton.rx.tap
            .withLatestFrom(chatView.textView.rx.text)
            .compactMap { $0 }
            .withUnretained(self)
            .bind { vc, chat in
                vc.chatViewModel.postChat(chat, to: vc.chatViewModel.matchedArray[1]) { dataCount in
                    vc.moveToBottom(dataCount)
                }
                vc.chatView.textView.text = ""
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - @objc
    
    @objc func touchupOkButton() {
        chatViewModel.requestDodge(otheruid: chatViewModel.matchedArray[1])
    }
    
    @objc func getMessage(notification: NSNotification) {
        print(#function)
        let id = notification.userInfo!["id"] as! String
        let chat = notification.userInfo!["text"] as! String
        let createdAt = notification.userInfo!["createdAt"] as! String
        let from = notification.userInfo!["from"] as! String
        let to = notification.userInfo!["to"] as! String
        
        let value = Chat(id: id, to: to, from: from, chat: chat, createdAt: createdAt)
        print("채팅 추가", value)
        chatView.tableView.reloadData()
        
        chatViewModel.chatResponse
            .withUnretained(self)
            .bind { vc, chats in
                vc.chatViewModel.chatList.append(contentsOf: chats)
                vc.chatView.tableView.scrollToRow(
                    at: IndexPath(row: chats.count - 1, section: 0),
                    at: .bottom, animated: false)
            }
            .disposed(by: disposeBag)
        chatViewModel.chatResponse.onNext([value])
    }
    
    // MARK: - Custom Method
    
    private func moveToBottom(_ dataCount: Int) {
        chatView.tableView.reloadData()
        DispatchQueue.main.async {
            self.chatView.tableView.scrollToRow(at: IndexPath(row: dataCount-1, section: 0), at: .bottom, animated: true)
        }
        SocketIOManager.shared.establishConnection()
    }
}

// MARK: - UITableViewDelegate

extension ChatViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ChatHeaderView()
        headerView.name = chatViewModel.matchedArray[0]
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
}
