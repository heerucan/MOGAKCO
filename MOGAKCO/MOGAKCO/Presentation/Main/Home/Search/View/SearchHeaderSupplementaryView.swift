//
//  SearchHeaderSupplementaryView.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/23.
//

import UIKit

import SnapKit
import Then

final class SearchHeaderSupplementaryView: UICollectionReusableView {
    
    static let identifier = "SearchHeaderSupplementaryView"
    
    // MARK: - Property
    
    let sectionLabel = UILabel().then {
        $0.font = Font.title6.font
        $0.textColor = Color.black
    }
    
    // MARK: - Initializer
      
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func configureLayout() {
        self.addSubview(sectionLabel)
        
        sectionLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
    }
}
