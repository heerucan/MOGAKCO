//
//  GenericResponse.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/12.
//

import Foundation

struct GenericResponse<T: Decodable>: Decodable {
    var status: Int
    var success: Bool?
    var message: String?
    var data: T?
    
    enum CodingKeys: String, CodingKey {
        case message
        case data
        case status
        case success
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        data = (try? values.decode(T.self, forKey: .data)) ?? nil
        status = (try? values.decode(Int.self, forKey: .status)) ?? 0
        success = (try? values.decode(Bool.self, forKey: .success)) ?? false
    }
}

struct VoidType: Decodable {}
