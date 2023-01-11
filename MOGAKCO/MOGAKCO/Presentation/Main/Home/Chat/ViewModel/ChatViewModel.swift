//
//  ChatViewModel.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/12/02.
//

import Foundation

import RxSwift
import RxCocoa

final class ChatViewModel: ViewModelType {
    
    var matchedArray = [""]
    var chatList = [Chat]()
    
    let chatResponse = BehaviorSubject<[Chat]>(value: [])
    let cancelResponse = BehaviorSubject<Int>(value: 0)
    let queueStateResponse = PublishRelay<QueueState>()
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(_ input: Input) -> Output {
        return Output()
    }
        
    // MARK: - Network
    
    /// 내 상태 확인
    func requestQueueState() {
        APIManager.shared
            .request(QueueState.self, QueueRouter.myQueueState) { [weak self] data, status, error in
                guard let self = self else { return }
                if let data = data {
                    self.queueStateResponse.accept(data)
                }
                if let error = error {
                    ErrorManager.handle(with: error, vc: HomeViewController(HomeViewModel()))
                }
            }
    }
    
    /// 채팅 전송  POST
    func postChat(_ chat: String, to: String, completion: @escaping ((Int) -> Void)) {
        APIManager.shared.request(Chat.self, ChatRouter.sendChat(chat: chat, to: to)) { [weak self] data, status, error in
            guard let self = self else { return }
            if let data = data {
                self.chatList.append(
                    Chat(id: data.id,
                         to: data.to,
                         from: data.from,
                         chat: data.chat,
                         createdAt: data.createdAt.toDate().toString(format: .special)))
                self.chatResponse.onNext(self.chatList)
                completion(self.chatList.count)
            }
            if let error = error {
                ErrorManager.handle(with: error, vc: ChatViewController(ChatViewModel()))
            }
        }
    }
    
    /// 채팅 리스트 가져오기 GET
    func fetchChat(from: String, lastchatDate: String, completion: @escaping ((Int) -> Void)) {
        APIManager.shared.request(ChatList.self, ChatRouter.getChatList(
            from: from, lastchatDate: lastchatDate)) { [weak self] data, status, error in
            guard let self = self else { return }
            if let data = data {
                data.payload.forEach {
                    self.chatList.append(
                        Chat(id: $0.id,
                             to: $0.to,
                             from: $0.from,
                             chat: $0.chat,
                             createdAt: $0.createdAt.toDate().toString(format: .special)))
                }
                self.chatResponse.onNext(self.chatList)
                completion(data.payload.count)
            }
                if let error = error {
                ErrorManager.handle(with: error, vc: ChatViewController(ChatViewModel()))
            }
        }
    }
    
    /// 스터디 취소하기 POST
    func requestDodge(otheruid: String) {
        APIManager.shared.request(Int.self, QueueRouter.dodge(otheruid)) { [weak self] _, status, error in
            guard let self = self else { return }
            if let status = status {
                self.cancelResponse.onNext(status)
            }
            if let error = error {
                ErrorManager.handle(with: error, vc: ChatViewController(ChatViewModel()))
            }
        }
    }
}
