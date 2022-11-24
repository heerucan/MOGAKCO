//
//  NavigationType.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/23.
//

import UIKit

// MARK: - Enum

@frozen
enum NavigationType {
    case my
    case myDetail
    case common
    case findSSAC
    case search
    
    var title: String {
        switch self {
        case .my: return "내정보"
        case .myDetail: return "정보 관리"
        case .common, .search: return ""
        case .findSSAC: return "새싹찾기"
        }
    }
    
    var rightButton: UIImage? {
        switch self {
        case .my, .myDetail, .common, .findSSAC, .search:
            return nil
        }
    }
    
    var rightButtonText: String? {
        switch self {
        case .myDetail: return "저장"
        case .my, .common, .search: return nil
        case .findSSAC: return "찾기 중단"
        }
    }
    
    var leftButton: UIImage? {
        switch self {
        case .my: return nil
        default: return Icon.arrow
        }
    }
    
    var lineViewBackgroundColor: UIColor {
        switch self {
        case .search: return .clear
        default: return Color.gray2
        }
    }
}
