//
//  SignupRequest.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/11.
//

import Foundation

/**
 Signup - 회원가입 요청 바디
 */

struct SignupRequest: Codable {
    let phoneNumber: String
    let FCMtoken: String
    let nick: String
    let birth: String
    let email: String
    let gender: Int
}

struct UserRequest: Codable {
    let searchable: Int
    let ageMin: Int
    let ageMax: Int
    let gender: Int
    let study: String
}
