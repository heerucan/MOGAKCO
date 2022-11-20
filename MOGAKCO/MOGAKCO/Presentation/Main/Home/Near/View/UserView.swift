//
//  UserView.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/19.
//

import UIKit

import SnapKit
import Then

final class UserView: BaseView {
    
//    var tasks: Results<Record>! {
//        didSet {
//            tableView.reloadData()
//        }
//    }
    
    // MARK: - Property
    
    let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.allowsSelection = false
        $0.backgroundColor = .white
        $0.register(MyDetailCardTableViewCell.self, forCellReuseIdentifier: MyDetailCardTableViewCell.identifier)
    }
    
    let emptyStateView = NearEmptyStateView(type: .user)
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }

    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        self.addSubviews([tableView,
                          emptyStateView])
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyStateView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
