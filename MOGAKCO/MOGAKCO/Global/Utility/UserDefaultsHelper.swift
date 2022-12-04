//
//  UserDefaultsHelper.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/13.
//

import Foundation

final class UserDefaultsHelper {
    private init() { }
    static let standard = UserDefaultsHelper()
    let userDefaults = UserDefaults.standard
    
    enum Key {
        static let idToken = "idToken"
        static let FCMtoken = "FCMtoken"
        static let myuid = "myuid"
        static let verificationID = "verificationID"
        static let phone = "phone"
        static let nickname = "nickname"
        static let birthday = "birthday"
        static let email = "email"
        static let gender = "gender"
        static let currentUser = "currentUser"
        static let lat = "lat"
        static let lng = "lng"
    }
    
    var idToken: String? {
        get { return userDefaults.string(forKey: Key.idToken) ?? "" }
        set { userDefaults.set(newValue, forKey: Key.idToken) }
    }
    
    var FCMtoken: String? {
        get { return userDefaults.string(forKey: Key.FCMtoken) ?? "" }
        set { userDefaults.set(APIKey.FCMtoken, forKey: Key.FCMtoken) }
    }
    
    var myuid: String? {
        get { return userDefaults.string(forKey: Key.myuid) ?? "" }
        set { userDefaults.set(newValue, forKey: Key.myuid) }
    }
    
    var verificationID: String? {
        get { return userDefaults.string(forKey: Key.verificationID) ?? "" }
        set { userDefaults.set(newValue, forKey: Key.verificationID) }
    }
    
    var phone: String? {
        get { return userDefaults.string(forKey: Key.phone) ?? "" }
        set { userDefaults.set(newValue, forKey: Key.phone) }
    }
    
    var nickname: String? {
        get { return userDefaults.string(forKey: Key.nickname) ?? "" }
        set { userDefaults.set(newValue, forKey: Key.nickname) }
    }
    
    var birthday: String? {
        get { return userDefaults.string(forKey: Key.birthday) ?? "" }
        set { userDefaults.set(newValue, forKey: Key.birthday) }
    }
    
    var email: String? {
        get { return userDefaults.string(forKey: Key.email) ?? "" }
        set { userDefaults.set(newValue, forKey: Key.email) }
    }
    
    var gender: Int {
        get { return userDefaults.integer(forKey: Key.gender) }
        set { userDefaults.set(newValue, forKey: Key.gender) }
    }
    
    var currentUser: Bool {
        get { return userDefaults.bool(forKey: Key.currentUser) }
        set { userDefaults.set(newValue, forKey: Key.currentUser) }
    }
    
    var lat: Double? {
        get { return userDefaults.double(forKey: Key.lat) }
        set { userDefaults.set(newValue, forKey: Key.lat) }
    }
    
    var lng: Double? {
        get { return userDefaults.double(forKey: Key.lng) }
        set { userDefaults.set(newValue, forKey: Key.lng) }
    }

    func removeObject() {
        userDefaults.removeObject(forKey: Key.idToken)
        userDefaults.removeObject(forKey: Key.FCMtoken)
        userDefaults.removeObject(forKey: Key.verificationID)
        userDefaults.removeObject(forKey: Key.phone)
        userDefaults.removeObject(forKey: Key.nickname)
        userDefaults.removeObject(forKey: Key.birthday)
        userDefaults.removeObject(forKey: Key.email)
        userDefaults.removeObject(forKey: Key.gender)
        userDefaults.removeObject(forKey: Key.lat)
        userDefaults.removeObject(forKey: Key.lng)
    }
    
    // 로그아웃을 위해
    func removeAccessToken() {
        userDefaults.removeObject(forKey: Key.idToken)
    }
}
