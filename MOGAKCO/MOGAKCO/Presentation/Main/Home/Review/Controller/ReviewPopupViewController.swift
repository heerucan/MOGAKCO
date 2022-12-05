//
//  ReviewPopupViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/12/06.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class ReviewPopupViewController: BaseViewController {

    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    private let reviewView = ReviewView()
    var reviewViewModel: ReviewViewModel!
    
    // MARK: - UI Property
    
    
    // MARK: - Init
    
    init(_ viewModel: ReviewViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.reviewViewModel = viewModel
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Bind
    
    override func bindViewModel() {
        
    }
    
    // MARK: - Custom Method
    
    
    // MARK: - @objc

}
