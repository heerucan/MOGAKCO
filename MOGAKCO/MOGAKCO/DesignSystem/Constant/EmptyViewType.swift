//
//  EmptyViewType.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/23.
//

import UIKit

// MARK: - Enum

@frozen
enum EmptyViewType {
    case user
    case request
    
    var title: String {
        switch self {
        case .user:
            return "아쉽게도 주변에 새싹이 없어요ㅠ"
        case .request:
            return "아직 받은 요청이 없어요ㅠ"
        }
    }
}
