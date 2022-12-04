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
        getChatData()
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
        chatViewModel.chatResponse
            .bind(to: chatView.tableView.rx.items) { [weak self] tableView, row, element in
                if element.from == self?.chatViewModel.otheruid {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: YourChatTableViewCell.identifier) as? YourChatTableViewCell
                    else { return UITableViewCell() }

//                    cell.timeLabel.text = DateFormatterHelper.shared.chatDateText(dateString: element.createdAt)
                    cell.chatLabel.text = element.chat

                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: MyChatTableViewCell.identifier) as? MyChatTableViewCell
                    else { return UITableViewCell() }
//                    cell.timeLabel.text = DateFormatterHelper.shared.chatDateText(dateString: element.createdAt)
                    cell.chatLabel.text = element.chat
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        /// 텍스트뷰 플레이스홀더 처리
        chatView.textView.rx.didBeginEditing
            .withUnretained(self)
            .subscribe { vc,_ in
                if vc.chatView.textView.textColor == Color.gray7 {
                    vc.chatView.textView.text = nil
                    vc.chatView.textView.textColor = Color.black
                }
            }
            .disposed(by: disposeBag)
        
        chatView.textView.rx.didEndEditing
            .withUnretained(self)
            .subscribe { vc,_ in
                if vc.chatView.textView.text == "" {
                    vc.chatView.textView.text = Matrix.Placeholder.chat
                    vc.chatView.textView.textColor = Color.gray7
                }
            }
            .disposed(by: disposeBag)
        
        /// 텍스트뷰 버튼 처리
        chatView.textView.rx.text
            .orEmpty
            .withUnretained(self)
            .bind { vc, text in
                if text.isEmpty || vc.chatView.textView.textColor == Color.gray7 {
                    vc.chatView.sendButton.setImage(Icon.sendInactive, for: .normal)
                } else {
                    vc.chatView.sendButton.setImage(Icon.send, for: .normal)
                }
            }
            .disposed(by: disposeBag)
        
        /// navigation Right Bar 처리
        // TODO: - 버튼 선택으로 변경해야 함
        chatView.navigationBar.rightButton.rx.tap
            .withLatestFrom(chatView.navigationBar.rightButton.rx.isSelected)
            .withUnretained(self)
            .bind { vc, value in
                print(value, "이거")
                vc.chatView.navigationBar.rightButton.isSelected.toggle()
                if value == false {
                    print(value, "눌럿을 떄")

                    UIView.animate(withDuration: 0.1) {
                        vc.chatView.chatMoreView.transform = CGAffineTransform(translationX: 0, y: 72)
                        vc.chatView.navigationBar.lineView.alpha = 0
                    }
                } else {
                    print(value, "안 눌럿을 떄")
                    UIView.animate(withDuration: 0.1) {
                        vc.chatView.chatMoreView.transform = .identity
                        vc.chatView.navigationBar.lineView.alpha = 1
                    }
                }
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
//                vc.navigationController?.popToRootViewController(animated: true)
                vc.transition(self, .popNavigations, 4)
            }
            .disposed(by: disposeBag)
        
        /// 채팅전송 버튼 -> 채팅전송 POST
        chatView.sendButton.rx.tap
            .withUnretained(self)
            .bind { vc,_ in
//                vc.chatViewModel.requestSendChat(<#T##chat: String##String#>)
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
        print(chatViewModel.otheruid, "취소")

    }
}
