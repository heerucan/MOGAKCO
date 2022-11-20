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
    private let nearViewModel = NearViewModel()    
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = requestView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    // MARK: - UI & Layout
   
    override func configureLayout() {
        
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = NearViewModel.Input()
        let output = nearViewModel.transform(input)
        
        nearViewModel.userList
            .withUnretained(self)
            .bind { vc, data in
                vc.requestView.emptyStateView.isHidden = data.count == 0 ? false : true
            }
            .disposed(by: disposeBag)

        nearViewModel.userList
            .bind(to: requestView.tableView.rx.items(
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
        let cell = requestView.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! MyDetailCardTableViewCell
        sender.isSelected ? cell.changeView(isSelected: true) : cell.changeView(isSelected: false)
        requestView.tableView.reloadSections(IndexSet(), with: .fade)
    }
}
