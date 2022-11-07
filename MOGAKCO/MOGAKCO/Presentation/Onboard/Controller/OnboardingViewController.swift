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
        
    }
    
    override func setupDelegate() {
        onboardView.collectionView.delegate = self
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        onboardViewModel.onboardList
            .bind(to: onboardView.collectionView.rx.items(
                cellIdentifier: OnboardCollectionViewCell.identifier,
                cellType: OnboardCollectionViewCell.self)) { (index, value, cell) in
                    cell.setupData(value, index)
                }
                .disposed(by: disposeBag)
    }
    
    // MARK: - Custom Method
    
    
    // MARK: - @objc
    
}

// MARK: - CollectionView

extension OnboardingViewController: UICollectionViewDelegate { }
