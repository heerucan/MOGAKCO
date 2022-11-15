//
//  MyReviewView.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/15.
//

import UIKit

import SnapKit
import Then

final class MyReviewView: BaseView {
    
    // MARK: - Property
    
    private lazy var reviewStackView = UIStackView(
        arrangedSubviews: [reviewTitleLabel, reviewLabel]).then {
            $0.axis = .vertical
            $0.spacing = 16
        }
    
    private let reviewTitleLabel = UILabel().then {
        $0.textColor = Color.black
        $0.font = Font.title6.font
        $0.text = "새싹 리뷰"
    }
    
    let reviewLabel = UILabel().then {
        $0.font = Font.body3.font
        $0.text = "첫 리뷰를 기다리는 중이에요!"
        $0.textColor = Color.gray6
    }
    
    private let reviewBottomView = UIView()
    
    let moreButton = UIButton().then {
        $0.setImage(Icon.moreArrow, for: .normal)
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }

    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        self.addSubviews([reviewStackView, moreButton])
        
        reviewStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints { make in
            make.top.equalTo(reviewTitleLabel.snp.top)
            make.trailing.equalToSuperview()
        }
    }
}
