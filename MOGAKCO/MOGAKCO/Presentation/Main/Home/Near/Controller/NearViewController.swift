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
    
    private let homeViewModel = HomeViewModel()
    private let nearViewModel = NearViewModel()
    
    // MARK: - PageViewController
    
    private var dataViewControllers: [UIViewController] {
        [userVC, requestVC]
    }
    
    private lazy var currentPage: Int = 0 {
        didSet {
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ?
                .forward : .reverse
            self.pageViewController.setViewControllers(
                [dataViewControllers[self.currentPage]],
                direction: direction,
                animated: true)
        }
    }
    
    private let userVC = NearUserViewController(nearViewModel: NearViewModel(), searchViewModel: SearchViewModel())
    private let requestVC = NearRequestViewController(nearViewModel: NearViewModel(),
                                                      searchViewModel: SearchViewModel(),
                                                      homeViewModel: HomeViewModel())
    
    private lazy var pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal)
    
    // MARK: - UI Property
    
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
        homeViewModel.requestRepeatedMyQueueStateAPI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        homeViewModel.stopRepeatedMyQueueStateAPI()
    }
    
    // MARK: - UI & Layout
    
    override func configureUI() {
        super.configureUI()
        changeValue(control: segmentedControl)
        userVC.userView.emptyStateView.changeButtonDelegate = self
        requestVC.requestView.emptyStateView.changeButtonDelegate = self
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
        
        navigationBar.rightButton.rx.tap
            .withUnretained(self)
            .bind { vc,_ in
                vc.nearViewModel.requestStopQueue()
            }
            .disposed(by: disposeBag)
        
        nearViewModel.queueResponse
            .withUnretained(self)
            .bind { vc, status in
                if status == 200 {
                    vc.navigationController?.popToRootViewController(animated: true)
                } else if status == 201 {
                    vc.showToast(Toast.stopFind.message)
                    vc.transition(ChatViewController(viewModel: ChatViewModel()), .push)
                }
            }
            .disposed(by: disposeBag)
        
        /// 내 매칭 상태를 5초마다 확인하고 -> 응답값에 따라 200 + matched = 1 이면 매칭된 걸로 판단해서 -> 채팅화면으로 전환
        homeViewModel.queueStateResponse
            .withUnretained(self)
            .bind { vc, value in
                if value == 1 {
                    print("🧡============ 매칭완료 채팅방 고고링 200 / 1 ============🧡")
                    vc.showToast(Toast.matchedStudy.message)
                    vc.transition(ChatViewController(viewModel: ChatViewModel()), .push)
                } else if value == 0 {
                    print("🧡============ 매칭대기중 200 / 0 ============🧡")
                }
            }
            .disposed(by: disposeBag)
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

// MARK: - ChangeButtonDelegate

extension NearViewController: ChangeButtonDelegate {
    func touchupChangeButton() {
        transition(self, .pop)
    }
}
