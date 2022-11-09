//
//  OnboardingViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import UIKit

import RxSwift
import RxCocoa

final class OnboardingViewController: BaseViewController {

    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    private let onboardView = OnboardView()
    private let onboardViewModel = OnboardViewModel()
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = onboardView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    // MARK: - UI & Layout
    
    override func configureUI() {
        super.configureUI()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func setupDelegate() {
        onboardView.collectionView.delegate = self
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = OnboardViewModel.Input()
        let output = onboardViewModel.transform(input)
        
        output.onboardList
            .bind(to: onboardView.collectionView.rx.items(
                cellIdentifier: OnboardCollectionViewCell.identifier,
                cellType: OnboardCollectionViewCell.self)) { (index, value, cell) in
                    cell.setupData(value, index)
                }
                .disposed(by: disposeBag)
        
        onboardView.collectionView.rx.willEndDragging
            .withUnretained(self)
            .subscribe(onNext: { (vc, arg1) in
                let (_, targetContentOffset) = arg1
                let page = Int(targetContentOffset.pointee.x / self.onboardView.collectionView.frame.width)
                self.onboardView.pageControl.currentPage = page
            })
            .disposed(by: disposeBag)
        
        onboardView.startButton.rx.tap
            .withUnretained(self)
            .bind { _ in
                self.presentSignupView()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Custom Method
    
    private func presentSignupView() {
        let viewController = AuthViewController()
        self.transition(viewController, .presentFullNavigation)
    }
}

// MARK: - CollectionView

extension OnboardingViewController: UICollectionViewDelegate { }
