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
                print(data, data.count)
                vc.userView.emptyStateView.isHidden = data.count == 0 ? false : true
            }
            .disposed(by: disposeBag)
        
        nearViewModel.userList
            .bind(to: userView.tableView.rx.items(
                cellIdentifier: UserTableViewCell.identifier,
                cellType: UserTableViewCell.self)) { row, element, cell in
//                    cell.setupData(data: )
                    cell.textLabel?.text = "\(element)"
                }
                .disposed(by: disposeBag)
        
        userView.tableView.rx.itemSelected
            .withUnretained(self)
            .bind { vc, indexPath in
                indexPath.item
            }
            .disposed(by: disposeBag)
        
    }
    
    // MARK: - Custom Method
    
    
    // MARK: - @objc
}

