//
//  PlainSegmentedControl.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/19.
//

import UIKit

import Then

final class PlainSegmentedControl: UISegmentedControl {
    
    // MARK: - Property
    
    private let lineView = UIView().then {
        $0.backgroundColor = Color.gray2
    }
    
    // MARK: - Initializer
    
    override init(items: [Any]?) {
        super.init(items: items)
        removeBackground()
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI & Layout
    
    private func removeBackground() {
        let image = UIImage()
        self.setBackgroundImage(image, for: .normal, barMetrics: .default)
        self.setBackgroundImage(image, for: .selected, barMetrics: .default)
        self.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        self.setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
    
    private func configureUI() {
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Color.green,
                                    NSAttributedString.Key.font: Font.title3.font], for: .selected)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Color.gray6,
                                     NSAttributedString.Key.font: Font.title4.font], for: .normal)
    }
    
    private func configureLayout() {
        addSubview(lineView)
        
        lineView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
