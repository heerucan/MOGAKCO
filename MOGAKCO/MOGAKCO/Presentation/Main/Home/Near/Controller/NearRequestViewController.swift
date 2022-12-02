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
    
    private let requestView = RequestView()
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
                vc.requestView.emptyStateView.isHidden = data.count == 0 ? false : true
            }
            .disposed(by: disposeBag)
        
        searchViewModel.searchResponse
            .map { $0.fromQueueDBRequested }
            .bind(to: requestView.tableView.rx.items(
                cellIdentifier: MyDetailCardTableViewCell.identifier,
                cellType: MyDetailCardTableViewCell.self)) { [weak self] row, element, cell in
                    print(element, "받은 요청=================================")
                    cell.index = row
                    cell.setupData(element, vc: NearRequestViewController.identifier)
                    cell.toggleButton.tag = row
                    cell.toggleButton.addTarget(self, action: #selector(self?.touchupToggleButton(_:)), for: .touchUpInside)
                    cell.requestDelegate = self
                }
                .disposed(by: disposeBag)
    }
    
    // MARK: - Custom Method
    
    
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
    @objc func touchupOkButton() {
        print("좋아")
        self.nearViewModel.otheruidSubject
            .withUnretained(self)
            .bind { vc, uid in
                print(uid, "============================== requestStudyAccept")
                vc.nearViewModel.requestStudyAccept(uid)
            }
            .disposed(by: disposeBag)
    }
    
    func requestOrAcceptButton(_ uid: String, index: Int) {
        print(index, uid, "===================================uid")
        self.nearViewModel.requestStudyAccept(uid)
        let alertVC = PlainAlertViewController()
        alertVC.alertType = .studyRequest
        alertVC.okButton.addTarget(self, action: #selector(self.touchupOkButton), for: .touchUpInside)
        self.transition(alertVC, .alert)
    }
}
