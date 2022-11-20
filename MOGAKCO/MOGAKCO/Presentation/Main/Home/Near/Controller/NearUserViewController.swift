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
    
    private let userView = UserView()
    private let nearViewModel = NearViewModel()    
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = userView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = NearViewModel.Input()
        let output = nearViewModel.transform(input)
        
        nearViewModel.userList
            .withUnretained(self)
            .bind { vc, data in
                vc.userView.emptyStateView.isHidden = data.count == 0 ? false : true
            }
            .disposed(by: disposeBag)

        nearViewModel.userList
            .bind(to: userView.tableView.rx.items(
                cellIdentifier: MyDetailCardTableViewCell.identifier,
                cellType: MyDetailCardTableViewCell.self)) { [weak self] row, element, cell in
                    cell.toggleButton.tag = row
                    cell.toggleButton.addTarget(self, action: #selector(self?.touchupToggleButton(_:)), for: .touchUpInside)
                    cell.toggleButton.isSelected ? cell.changeView(isSelected: true) : cell.changeView(isSelected: false)
                }
                .disposed(by: disposeBag)
    }
    
    // MARK: - Custom Method
    
    
    // MARK: - @objc
    
    @objc func touchupToggleButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let cell = userView.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! MyDetailCardTableViewCell
        sender.isSelected ? cell.changeView(isSelected: true) : cell.changeView(isSelected: false)
        userView.tableView.reloadSections(IndexSet(), with: .fade)
    }
}
