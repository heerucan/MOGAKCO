//
//  ChatViewModel.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/12/02.
//

import Foundation

import RxSwift

final class ChatViewModel: ViewModelType {
    
    var otheruid = ""
    var chat = [Chat]()
    let chatResponse = PublishSubject<[Chat]>()
    let cancelResponse = BehaviorSubject<Int>(value: 0)
    let payloadResponse = BehaviorSubject<ChatList>(value: ChatList.init(payload: []))
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(_ input: Input) -> Output {
        return Output()
    }
    
    // MARK: - Network

//    private func fetchChats() {
//        let header: HTTPHeaders = [
//            "Authorization": "Bearer \(APIKey.header)",
//            "Content-Type": "application/json"
//        ]
//
//        AF.request(APIKey.url, method: .get, headers: header).responseDecodable(of: [Chat].self) { [weak self] response in
//            switch response.result {
//            case .success(let value):
//                self?.chat = value
//                self?.tableView.reloadData()
//                self?.tableView.scrollToRow(at: IndexPath(row: self!.chat.count - 1, section: 0), at: .bottom, animated: false)
//
//                // 여기 쓰는 이유는 이전 채팅들도 처리해줘야 하니까
//                SocketIOManager.shared.establishConnection()
//
//            case .failure(let error):
//                print("FAIL", error)
//            }
//        }
//    }
    
    /// 채팅 전송  POST
    func postChat(_ chat: String, to: String) {
        APIManager.shared.request(Chat.self, ChatRouter.sendChat(chat: chat, to: to)) { [weak self] data, status, error in
            guard let self = self else { return }
            if let data = data {
                self.chatResponse.onNext([data])
            }
            if let error = error {
                ErrorManager.handle(with: error, vc: ChatViewController(viewModel: ChatViewModel(),
                                                                        homeViewModel: HomeViewModel()))
            }
        }
    }
    
    /// 채팅 리스트 가져오기 GET
    func requestChatList(from: String, lastchatDate: String) {
        APIManager.shared.request(ChatList.self, ChatRouter.getChatList(from: from, lastchatDate: lastchatDate)) { [weak self] data, status, error in
            guard let self = self else { return }
            if let data = data {
                self.payloadResponse.onNext(data)
            }
            if let error = error {
                ErrorManager.handle(with: error, vc: ChatViewController(viewModel: ChatViewModel(),
                                                                        homeViewModel: HomeViewModel()))
            }
        }
    }
    
    /// 스터디 취소하기 POST
    func requestDodge(otheruid: String) {
        APIManager.shared.request(Int.self, QueueRouter.dodge(otheruid)) { [weak self] _, status, error in
            print(otheruid, "취소")
            guard let self = self else { return }
            if let status = status {
                self.cancelResponse.onNext(status)
            }
            if let error = error {
                ErrorManager.handle(with: error, vc: ChatViewController(viewModel: ChatViewModel(),
                                                                        homeViewModel: HomeViewModel()))
            }
        }
    }
}
