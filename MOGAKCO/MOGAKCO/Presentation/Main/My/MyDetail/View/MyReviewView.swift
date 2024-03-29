//
//  MyReviewView.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/15.
//

import UIKit

import SnapKit
import Then

protocol ReviewMoreButtonDelegate: AnyObject {
    func touchpuReviewMoreButton()
}

final class MyReviewView: BaseView {
    
    // MARK: - Property
    
    weak var reviewMoreButtonDelegate: ReviewMoreButtonDelegate?
    
    // TODO: - review 더보기 버튼 관련 화면전환 연결하기
    lazy var reviewMoreAction = UIAction { _ in
        self.reviewMoreButtonDelegate?.touchpuReviewMoreButton()
    }
    
    var reviewData: [String] = [] {
        didSet {
            print(reviewData, "에에에에")
        }
    }
        
    private lazy var reviewStackView = UIStackView(arrangedSubviews: [reviewTitleLabel, reviewLabel]).then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .fill
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
        $0.numberOfLines = 0
    }
    
    private let reviewBottomView = UIView()
    
    private let moreButton = UIButton().then {
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
    
    func setupData(_ data: User) {
        if !data.comment.isEmpty {
            reviewLabel.text = data.comment[0]
            reviewLabel.textColor = Color.black
        }
        moreButton.isHidden = data.comment.count >= 2 ? false : true
    }
    
    func setupData(_ data: FromQueueDB) {
        if !data.reviews.isEmpty {
            reviewLabel.text = data.reviews[0]
            reviewLabel.textColor = Color.black
        }
        moreButton.isHidden = data.reviews.count >= 2 ? false : true
    }
}
