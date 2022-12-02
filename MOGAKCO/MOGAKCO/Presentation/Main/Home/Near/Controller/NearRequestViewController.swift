//
//  NearRequestViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/19.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class NearRequestViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    let requestView = RequestView()
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
        self.view = requestView
    }
    
    override func viewDidLoad() {
        print(#function, "NearRequestVC")
        super.viewDidLoad()
        bindViewModel()
    }

    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = NearViewModel.Input()
        let output = nearViewModel.transform(input)
        
        searchViewModel.requestSearch(lat: Matrix.ssacLat, long: Matrix.ssacLong)
        
        searchViewModel.searchResponse
            .map { $0.fromQueueDBRequested }
            .withUnretained(self)
            .bind { vc, data in
                print(data, "내가 받은 요청~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                vc.requestView.emptyStateView.isHidden = data.count == 0 ? false : true
            }
            .disposed(by: disposeBag)
        
        searchViewModel.searchResponse
            .map { $0.fromQueueDBRequested }
            .bind(to: requestView.tableView.rx.items(
                cellIdentifier: MyDetailCardTableViewCell.identifier,
                cellType: MyDetailCardTableViewCell.self)) { [weak self] row, element, cell in
                    cell.index = row
                    cell.setupData(element, vc: NearRequestViewController.identifier)
                    cell.toggleButton.tag = row
                    cell.toggleButton.addTarget(self, action: #selector(self?.touchupToggleButton(_:)), for: .touchUpInside)
                    cell.requestDelegate = self
                }
                .disposed(by: disposeBag)
    }
    
    // MARK: - @objc
    
    @objc func touchupToggleButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let cell = requestView.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! MyDetailCardTableViewCell
        cell.changeView(sender.isSelected, vc: NearRequestViewController.identifier)
        requestView.tableView.reloadSections(IndexSet(), with: .fade)
    }
}

// MARK: - RequestOrAcceptDelegate

extension NearRequestViewController: RequestOrAcceptDelegate {
    func requestOrAcceptButton(_ uid: String, index: Int) {
        print("이거 이거이거잉?request 버튼 누른 겨?")
        let alertVC = PlainAlertViewController()
        alertVC.alertType = .studyAccept
        alertVC.okButton.addTarget(self, action: #selector(self.touchupOkButton), for: .touchUpInside)
        self.transition(alertVC, .alert)
        nearViewModel.uid = uid
    }
    
    @objc func touchupOkButton() {
        nearViewModel.requestStudyAccept(nearViewModel.uid)
    }
}
