//
//  BaseTableViewCell.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import UIKit

class BaseTableViewCell: UITableViewCell, BaseMethodProtocol {
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        configureLayout()
        setupDelegate()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() { }
    func configureLayout() { }
    func bindViewModel() { }
    func setupDelegate() { }
}
