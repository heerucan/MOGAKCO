//
//  MyViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/13.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class MyViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    var myViewModel: MyViewModel!

    
    // MARK: - UI Property
    
    private lazy var navigationBar = PlainNavigationBar(type: .my).then {
        $0.viewController = self
    }
    
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.register(MyProfileTableViewCell.self, forCellReuseIdentifier: MyProfileTableViewCell.identifier)
    }
    
    
    // MARK: - Init
    
    init(myViewModel: MyViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.myViewModel = myViewModel
    }
    
    // MARK: - Initializer

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    // MARK: - UI & Layout
   
    override func configureLayout() {
        view.addSubviews([navigationBar, tableView])
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.layoutMarginsGuide)
            make.directionalHorizontalEdges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }    
    
    // MARK: - Bind
    
    override func bindViewModel() {

        let input = MyViewModel.Input(itemSelected: tableView.rx.itemSelected)
        let output = myViewModel.transform(input)
        
        output.myProfileList
            .bind(to: tableView.rx.items(
                cellIdentifier: MyProfileTableViewCell.identifier,
                cellType: MyProfileTableViewCell.self)) { row, element, cell in
                    cell.setupData(data: element)
                    row == 0 ? cell.configureNameLayout() : cell.configureMenuLayout()
                }
                .disposed(by: disposeBag)
        
        output.itemSelected
            .withUnretained(self)
            .bind { vc, indexPath in
                if indexPath.row == 0 {
                    vc.transition(MyDetailViewController(myDetailViewModel: MyDetailViewModel()), .push)
                }
            }
            .disposed(by: disposeBag)
    }
}
