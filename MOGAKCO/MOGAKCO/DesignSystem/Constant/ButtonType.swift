//
//  ButtonType.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/23.
//

import UIKit

// MARK: - Enum

@frozen
enum HeightType {
    case h48
    case h32
    case h40
    
    var height: CGFloat {
        switch self {
        case .h48:
            return 48
        case .h32:
            return 32
        case .h40:
            return 40
        }
    }
}
