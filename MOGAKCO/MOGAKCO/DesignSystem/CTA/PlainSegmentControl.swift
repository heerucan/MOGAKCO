//
//  PlainSegmentedControl.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/19.
//

import UIKit

final class PlainSegmentedControl: UISegmentedControl {
    
    // MARK: - Initializer
    
    override init(items: [Any]?) {
        super.init(items: items)
        removeBackground()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI & Layout
    
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
}
