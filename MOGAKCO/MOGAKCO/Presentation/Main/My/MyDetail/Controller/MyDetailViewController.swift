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

final class MyDetailViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
        
    private let myDetailViewModel = MyDetailViewModel()
    
    private lazy var navigationBar = PlainNavigationBar(type: .myDetail).then {
        $0.viewController = self
    }
    
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.sectionHeaderTopPadding = 0
        $0.backgroundColor = .white
        $0.bounces = false
        $0.allowsSelection =  false
        $0.rowHeight = UITableView.automaticDimension
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
    
    override func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyDetailCardTableViewCell.self, forCellReuseIdentifier: MyDetailCardTableViewCell.identifier)
        tableView.register(MyDetailInfoTableViewCell.self, forCellReuseIdentifier: MyDetailInfoTableViewCell.identifier)
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
//        let input = MyDetailViewModel.Input(tap: .rx.tap)
//        let output = homeViewModel.transform(input)
//
//        output.tap
//            .withUnretained(self)
//            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
//            .subscribe { (vc,_) in
//                vc.requestWithdraw()
//            }
//            .disposed(by: disposeBag)
    }
    
    // MARK: - Network
    
    private func requestWithdraw() {
//        APIManager.shared.requestData(Int.self, AuthRouter.withdraw) { [weak self] response in
//            guard let self = self else { return }
//            switch response {
//            case .success(let value):
//                print("🟣성공 ->>> \n", value)
//                self.handle(with: .success)
//                UserDefaultsHelper.standard.removeObject()
//                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
//                let sceneDelegate = windowScene?.delegate as? SceneDelegate
//                let viewController = OnboardingViewController()
//                sceneDelegate?.window?.rootViewController = viewController
//                sceneDelegate?.window?.makeKeyAndVisible()
//
//            case .failure(let error):
//                self.handle(with: error)
//                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
//                let sceneDelegate = windowScene?.delegate as? SceneDelegate
//                let viewController = OnboardingViewController()
//                sceneDelegate?.window?.rootViewController = viewController
//                sceneDelegate?.window?.makeKeyAndVisible()
//            }
//        }
    }
    // MARK: - @objce
    
    @objc func touchupToggleButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MyDetailCardTableViewCell
        sender.isSelected ? cell.changeView(isSelected: true) : cell.changeView(isSelected: false)
        tableView.reloadSections(IndexSet(), with: .fade)
    }
}

// MARK: - TableView

extension MyDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        switch section {
//        case 0: return MyDetailImageView()
//        default: return UIView()
//        }
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let nameCell = tableView.dequeueReusableCell(withIdentifier: MyDetailCardTableViewCell.identifier, for: indexPath) as? MyDetailCardTableViewCell
            else { return UITableViewCell() }
            nameCell.toggleButton.addTarget(self, action: #selector(touchupToggleButton(_:)), for: .touchUpInside)
            return nameCell
        } else {
            guard let infoCell = tableView.dequeueReusableCell(withIdentifier: MyDetailInfoTableViewCell.identifier, for: indexPath) as? MyDetailInfoTableViewCell
            else { return UITableViewCell() }
//            infoCell.withdrawButton
            return infoCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
