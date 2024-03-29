//
//  SplashViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import UIKit

import SnapKit
import Then

final class SplashViewController: BaseViewController {
    
    // MARK: - Property
    
    private let logoImageView = UIImageView().then {
        $0.image = Icon.splashLogo
        $0.alpha = 0
    }
    
    private let titleImageView = UIImageView().then {
        $0.image = Icon.txt
        $0.alpha = 0
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAnimation()
    }
    
    // MARK: - UI & Layout
    
    override func configureLayout() {
        view.addSubviews([logoImageView,
                         titleImageView])
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(216)
            make.centerX.equalToSuperview()
        }
        
        titleImageView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(34)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Custom Method
    
    private func configureAnimation() {
        UIView.animate(withDuration: 2, delay: 0.5) {
            self.logoImageView.alpha = 1
            self.titleImageView.alpha = 1
        } completion: { [weak self] _ in
            guard let self = self else { return }
            
            if UserDefaultsHelper.standard.currentUser == false {
                // 신규 사용자
                let viewController = OnboardingViewController()
                viewController.modalPresentationStyle = .fullScreen
                viewController.modalTransitionStyle = .crossDissolve
                self.present(viewController, animated: false, completion: nil)
            } else if UserDefaultsHelper.standard.currentUser == true {
                // 기존 사용자
                let viewController = UINavigationController(rootViewController: TabBarController())
                viewController.modalPresentationStyle = .fullScreen
                viewController.modalTransitionStyle = .crossDissolve
                viewController.navigationBar.isHidden = true
                self.present(viewController, animated: false, completion: nil)
            }
        }
    }
}
