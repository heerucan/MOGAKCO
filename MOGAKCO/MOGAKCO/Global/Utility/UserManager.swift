//
//  UserManager.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/11.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    let storage: UserDefaults
    
    init(key: String, defaultValue: T, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }
    
    var wrappedValue: T {
        get { self.storage.object(forKey: key) as? T ?? defaultValue }
        set { self.storage.set(newValue, forKey: key) }
    }
}

/**
 UserManager : UserDefaults를 관리하기 위한 매니저 클래스
 */

final class UserManager {
    @UserDefault(key: Matrix.verificationID, defaultValue: nil)
    static var verificationID: String?
    
    @UserDefault(key: Matrix.idToken, defaultValue: nil)
    static var idToken: String?
    
    @UserDefault(key: Matrix.FCMtoken, defaultValue: nil)
    static var FCMtoken: String?
    
    @UserDefault(key: "phone", defaultValue: nil)
    static var phone: String?
    
    @UserDefault(key: "nickname", defaultValue: nil)
    static var nickname: String?
    
    @UserDefault(key: "birthday", defaultValue: nil)
    static var birthday: String?
    
    @UserDefault(key: "email", defaultValue: nil)
    static var email: String?
    
    @UserDefault(key: "gender", defaultValue: 0)
    static var gender: Int
}
