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
    private var chatViewModel: ChatViewModel!
    
    // MARK: - UI Property
    
    private lazy var navigationBar = PlainNavigationBar(type: .chat).then {
        $0.viewController = self
    }
    
    // MARK: - Init
    
    init(viewModel: ChatViewModel) {
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
    }
    
    // MARK: - UI & Layout
    
    override func configureLayout() {
        view.addSubviews([navigationBar])
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalToSuperview()
        }
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
    }
    
    // MARK: - Custom Method
    
    
    // MARK: - @objc
}
