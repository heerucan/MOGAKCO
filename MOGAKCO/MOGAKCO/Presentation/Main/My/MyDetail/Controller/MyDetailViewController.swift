//
//  MyDetailViewController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/14.
//

import UIKit

import SnapKit
import Then
import RxSwift

final class MyDetailViewController: BaseViewController {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
        
    // MARK: - Property
    
    private let myDetailViewModel = MyDetailViewModel()
    private let myDetailView = MyDetailView()
    
    private let navigationBar = PlainNavigationBar(type: .myDetail)
    
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .blue
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
    }
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = myDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    // MARK: - UI & Layout
   
    override func configureLayout() {
        view.addSubviews([navigationBar, tableView])
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.directionalHorizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyDetailTableViewCell.self, forCellReuseIdentifier: MyDetailTableViewCell.identifier)
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        
        let input = MyDetailViewModel.Input()
        let output = myDetailViewModel.transform(input)

    }
    
    // MARK: - Network

}

// MARK: - TableView

extension MyDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
