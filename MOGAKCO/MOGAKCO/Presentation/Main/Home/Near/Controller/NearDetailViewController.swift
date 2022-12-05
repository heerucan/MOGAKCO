//
//  NearDetailViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/24.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class NearDetailViewController: BaseViewController {

    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    private lazy var navigationBar = PlainNavigationBar(type: .findSSAC).then {
        $0.viewController = self
    }
    
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.identifier)
        $0.backgroundColor = .white
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UI & Layout
    
    override func configureUI() {
        view.backgroundColor = .white
    }
    
    override func configureLayout() {
        view.addSubviews([navigationBar, tableView])
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.layoutMarginsGuide)
            make.directionalHorizontalEdges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.directionalHorizontalEdges.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        
    }
}
