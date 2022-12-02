//
//  NearEmptyStateView.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/19.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

/**
 NearEmptyStateView
 - 새싹 찾기 뷰에 사용되는 엠티스테이트 뷰
 */

protocol ChangeButtonDelegate: AnyObject {
    func touchupChangeButton()
}

final class NearEmptyStateView: BaseView {
    
    // MARK: - DisposeBag
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    
    weak var changeButtonDelegate: ChangeButtonDelegate?
    
    private let nearViewModel = NearViewModel()
    private let searchViewModel = SearchViewModel()
    
    let viewType: EmptyViewType = .user
        
    private let imageView = UIImageView().then {
        $0.image = Icon.sprout
    }
    
    private let titleLabel = UILabel().then {
        $0.font = Font.display1.font
        $0.textColor = Color.black
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "스터디를 변경하거나 조금만 더 기다려 주세요!"
        $0.font = Font.title4.font
        $0.textColor = Color.gray7
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [changeButton, refreshButton]).then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    let changeButton = PlainButton(.fill, height: .h48).then {
        $0.title = "스터디 변경하기"
    }
    
    private lazy var refreshButton = PlainButton(.outline, height: .h48).then {
        $0.setImage(Icon.refresh, for: .normal)
    }
    
    // MARK: - Initializer
    
    init(type: EmptyViewType) {
        super.init(frame: .zero)
        bindViewModel()
        titleLabel.text = type.title
    }

    // MARK: - Configure UI & Layout
    
    override func configureLayout() {
        self.addSubviews([imageView,
                         titleLabel,
                          subTitleLabel,
                          stackView])
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(187)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(45)
            make.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.directionalHorizontalEdges.equalToSuperview().inset(48)
        }
        
        stackView.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(16)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.width.equalTo(48)
        }
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        changeButton.rx.tap
            .withUnretained(self)
            .bind { vc,_ in
                vc.nearViewModel.requestStopQueue()
                vc.changeButtonDelegate?.touchupChangeButton()
            }
            .disposed(by: disposeBag)
      
        refreshButton.rx.tap
            .withUnretained(self)
            .bind { vc,_ in
                vc.searchViewModel.requestSearch(
                    lat: UserDefaultsHelper.standard.lat!,
                    long: UserDefaultsHelper.standard.lng!)
            }
            .disposed(by: disposeBag)
    }
}
