//
//  RequestView.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/19.
//

import UIKit

import SnapKit
import Then

final class RequestView: BaseView {
    
//    var tasks: Results<Record>! {
//        didSet {
//            tableView.reloadData()
//        }
//    }
    
    // MARK: - Property
    
    let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(RequestTableViewCell.self, forCellReuseIdentifier: RequestTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.allowsSelection = false
        $0.backgroundColor = .white
        $0.register(MyDetailCardTableViewCell.self, forCellReuseIdentifier: MyDetailCardTableViewCell.identifier)
    }
    
    let emptyStateView = NearEmptyStateView(type: .request)
    
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
