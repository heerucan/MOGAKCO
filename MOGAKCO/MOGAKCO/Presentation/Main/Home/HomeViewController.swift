//
//  HomeViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/13.
//

import UIKit

import SnapKit
import Then
import RxSwift

final class HomeViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
        
    // MARK: - Property
    
    let homeViewModel = HomeViewModel()
    let homeView = HomeView()
    
    let button = UIButton().then {
        $0.setTitle("탈퇴", for: .normal)
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        UserDefaultsHelper.standard.currentUser = true
    }
    
    // MARK: - UI & Layout
    
    override func configureUI() {
        view.backgroundColor = .red
    }
    
    override func configureLayout() {
        view.addSubviews([button])
        
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = HomeViewModel.Input(tap: button.rx.tap)
        let output = homeViewModel.transform(input)

        output.tap
            .withUnretained(self)
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe { (vc,_) in
                vc.requestWithdraw()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Network
    
    private func requestWithdraw() {
        APIManager.shared.requestData(Int.self, AuthRouter.withdraw) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let value):
                print("🟣성공 ->>> \n", value)
                self.handle(with: .success)
                UserDefaultsHelper.standard.removeObject()
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                let viewController = OnboardingViewController()
                sceneDelegate?.window?.rootViewController = viewController
                sceneDelegate?.window?.makeKeyAndVisible()

            case .failure(let error):
                self.handle(with: error)
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                let viewController = OnboardingViewController()
                sceneDelegate?.window?.rootViewController = viewController
                sceneDelegate?.window?.makeKeyAndVisible()
            }
        }
    }
}
