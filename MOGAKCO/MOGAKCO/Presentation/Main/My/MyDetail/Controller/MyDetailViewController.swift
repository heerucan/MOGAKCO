//
//  MyDetailViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/14.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class MyDetailViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
        
    private let myDetailViewModel = MyDetailViewModel()
    private let messageViewModel = MessageViewModel()
    
    // MARK: - UI Property
    
    private lazy var navigationBar = PlainNavigationBar(type: .myDetail).then {
        $0.viewController = self
    }
    
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.keyboardDismissMode = .onDrag
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.sectionHeaderTopPadding = 0
        $0.bounces = false
        $0.allowsSelection =  false
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = UITableView.automaticDimension
        $0.register(MyDetailCardTableViewCell.self, forCellReuseIdentifier: MyDetailCardTableViewCell.identifier)
        $0.register(MyDetailInfoTableViewCell.self, forCellReuseIdentifier: MyDetailInfoTableViewCell.identifier)
    }
    
    private lazy var withdrawAction = UIAction { _ in
        print("탈퇴버튼")
//        self.myDetailViewModel.requestWithdraw()
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    // MARK: - UI & Layout
    
    override func configureLayout() {
        view.addSubviews([navigationBar, tableView])
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        myDetailViewModel.requestUser()
        
        // user get
        myDetailViewModel.userResponse
            .withUnretained(self)
            .bind { vc, value in
                print(value, "유저응답값")
            }
            .disposed(by: disposeBag)
        
        myDetailViewModel.userResponse
            .bind(to: tableView.rx.items) { [weak self] (tableView, row, item) -> UITableViewCell in
                guard let self = self else { return UITableViewCell() }
                if row == 0 {
                    let cell = self.tableView.dequeueReusableCell(
                        withIdentifier: MyDetailCardTableViewCell.identifier,
                        for: IndexPath(row: row, section: 0)) as! MyDetailCardTableViewCell
                    cell.setupData(item)
                    cell.toggleButton.addTarget(self, action: #selector(self.touchupToggleButton(_:)), for: .touchUpInside)
                    return cell
                } else {
                    let cell = self.tableView.dequeueReusableCell(
                        withIdentifier: MyDetailInfoTableViewCell.identifier,
                        for: IndexPath(row: row, section: 0)) as! MyDetailInfoTableViewCell
                    cell.setupData(item)
                    cell.withdrawButton.addAction(self.withdrawAction, for: .touchUpInside)
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        // 탈퇴
        myDetailViewModel.withdrawResponse
            .withUnretained(self)
            .bind { cell, status in
                if status == 200 {
                    UserDefaultsHelper.standard.removeObject()
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    let sceneDelegate = windowScene?.delegate as? SceneDelegate
                    let viewController = OnboardingViewController()
                    sceneDelegate?.window?.rootViewController = viewController
                    sceneDelegate?.window?.makeKeyAndVisible()
                }
            }
            .disposed(by: disposeBag)
        
        // 정보 저장
//        navigationBar.rightButton.rx.tap
//            .withUnretained(self)
//            .bind {vc,_ in
//                vc.myDetailViewModel.requestUpdateMypage(params: <#T##UserRequest#>)
//            }
//            .disposed(by: disposeBag)
        
    }
        
    // MARK: - @objc
    
    @objc func touchupToggleButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MyDetailCardTableViewCell
        cell.changeView(sender.isSelected, vc: MyDetailViewController.identifier)
        tableView.reloadSections(IndexSet(), with: .fade)
    }
}
