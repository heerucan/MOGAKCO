//
//  ReviewViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/12/06.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class ReviewViewController: BaseViewController {

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
    
    override func loadView() {
        self.view = reviewView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut) { [weak self] in
            guard let self = self else { return }
            self.view.backgroundColor = Color.black.withAlphaComponent(0.5)
        }
    }

    // MARK: - UI & Layout
    
    override func configureUI() {
        view.backgroundColor = Color.black.withAlphaComponent(0)
    }

    // MARK: - Bind
    
    override func bindViewModel() {
        
    }
    
    // MARK: - Custom Method
    
    
    // MARK: - @objc

}
