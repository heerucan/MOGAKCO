//
//  NearUserViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/19.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class NearUserViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
        
    let userView = UserView()
    var nearViewModel: NearViewModel!
    var searchViewModel: SearchViewModel!
            
    // MARK: - Init
    
    init(nearViewModel: NearViewModel, searchViewModel: SearchViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.nearViewModel = nearViewModel
        self.searchViewModel = searchViewModel
    }

    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = userView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchViewModel.requestSearch(lat: UserDefaultsHelper.standard.lat!, long: UserDefaultsHelper.standard.lng!)
    }

    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = NearViewModel.Input()
        let output = nearViewModel.transform(input)
        
        // TODO: - 여기 바꿔야 함 사용자가 스터디뷰에서까지 설정한 좌표로
        searchViewModel.requestSearch(lat: Matrix.ssacLat, long: Matrix.ssacLong)

        searchViewModel.searchResponse
            .map { $0.fromQueueDB }
            .withUnretained(self)
            .bind { vc, data in
                vc.userView.emptyStateView.isHidden = data.count == 0 ? false : true
            }
            .disposed(by: disposeBag)
        
        searchViewModel.searchResponse
            .map { $0.fromQueueDB }
            .bind(to: userView.tableView.rx.items(
                cellIdentifier: MyDetailCardTableViewCell.identifier,
                cellType: MyDetailCardTableViewCell.self)) { [weak self] row, element, cell in
                    guard let self = self else { return }
                    cell.index = row
                    cell.setupData(element, vc: NearUserViewController.identifier)
                    cell.toggleButton.tag = row
                    cell.toggleButton.addTarget(self, action: #selector(self.touchupToggleButton(_:)), for: .touchUpInside)
                    cell.requestDelegate = self
                }
                .disposed(by: disposeBag)
        
        nearViewModel.requestResponse
            .withUnretained(self)
            .bind { vc, status in
                if status == 200 {
                    vc.showToast(Toast.studyRequestSuccess.message)
                } else if status == 201 {
                    vc.nearViewModel.requestStudyAccept(vc.nearViewModel.uid)
                } else if status == 202 {
                    vc.showToast(Toast.stopFindStudy.message)
                }
            }
            .disposed(by: disposeBag)
        
        nearViewModel.acceptResponse
            .withUnretained(self)
            .bind { vc, status in
                if status == 200 {
                    vc.showToast(Toast.matchingStudy.message)
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                        vc.transition(ChatViewController(viewModel: ChatViewModel()), .push)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - @objc

    @objc func touchupToggleButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let cell = userView.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! MyDetailCardTableViewCell
        cell.changeView(sender.isSelected, vc: NearUserViewController.identifier)
        userView.tableView.reloadSections(IndexSet(), with: .fade)
    }
}

// MARK: - RequestOrAcceptDelegate

extension NearUserViewController: RequestOrAcceptDelegate {
    func requestOrAcceptButton(_ uid: String, index: Int) {
        let alertVC = PlainAlertViewController()
        alertVC.alertType = .studyRequest
        alertVC.okButton.addTarget(self, action: #selector(self.touchupOkButton), for: .touchUpInside)
        self.transition(alertVC, .alert)
        nearViewModel.uid = uid
    }
    
    @objc func touchupOkButton() {
        nearViewModel.requestStudyRequest(nearViewModel.uid)
    }
}
