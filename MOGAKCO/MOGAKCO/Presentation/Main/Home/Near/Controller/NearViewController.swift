//
//  NearViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/19.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class NearViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    private let nearViewModel = NearViewModel()
    
    private var dataViewControllers: [UIViewController] {
        [firstViewController, secondViewController]
    }
    
    private lazy var currentPage: Int = 0 {
        didSet {
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
            self.pageViewController.setViewControllers([dataViewControllers[self.currentPage]],
                                                       direction: direction,
                                                       animated: true)
        }
    }
    
    private let firstViewController = NearUserViewController()
    private let secondViewController = NearRequestViewController()
    
    private lazy var pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal)
    
    private lazy var navigationBar = PlainNavigationBar(type: .findSSAC).then {
        $0.viewController = self
    }
    
    private let segmentedControl = PlainSegmentedControl(items: ["주변 새싹", "받은 요청"]).then {
        $0.selectedSegmentIndex = 0
        $0.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
    }

    private let lineView = UIView().then {
        $0.backgroundColor = Color.green
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    // MARK: - UI & Layout
    
    override func configureUI() {
        super.configureUI()
        changeValue(control: segmentedControl)
    }
   
    override func configureLayout() {
        view.addSubviews([navigationBar,
                          segmentedControl,
                          lineView])
        addChild(pageViewController)
        view.addSubview(pageViewController.view)

        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.layoutMarginsGuide)
            make.directionalHorizontalEdges.equalToSuperview()
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.directionalHorizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(-2)
            make.leading.equalToSuperview()
            make.height.equalTo(2)
            make.width.equalTo(view.frame.width/2)
        }
        
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
    }
    
    // MARK: - Custom Method
    
    private func changeLinePosition() {
        let segmentIndex = CGFloat(segmentedControl.selectedSegmentIndex)
        let segmentWidth = segmentedControl.frame.width / 2
        let leadingDistance = segmentWidth * segmentIndex
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.lineView.transform = CGAffineTransform(translationX: leadingDistance, y: 0)
        })
    }
    // MARK: - @objc
    
    @objc private func changeValue(control: UISegmentedControl) {
        currentPage = control.selectedSegmentIndex
        changeLinePosition()
    }
}
