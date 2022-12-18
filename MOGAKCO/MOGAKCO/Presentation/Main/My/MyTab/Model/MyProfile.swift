//
//  MyProfile.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/20.
//

import UIKit

struct MyProfile {
    let image: UIImage?
    let menu: String
    let arrowIsHidden: Bool
    
    init(image: UIImage?, menu: String, arrowIsHidden: Bool = true) {
        self.image = image
        self.menu = menu
        self.arrowIsHidden = arrowIsHidden
    }
}

struct MyProfileData {
    func getMyProfileList() -> [MyProfile] {
        return [MyProfile(image: UIImage(named: Icon.sesac_face_1),
                          menu: UserDefaultsHelper.standard.nickname ?? "김새싹",
                          arrowIsHidden: false),
                MyProfile(image: Icon.notice, menu: "공지사항"),
                MyProfile(image: Icon.faq, menu: "자주 묻는 질문"),
                MyProfile(image: Icon.qna, menu: "1:1 문의"),
                MyProfile(image: Icon.settingAlarm, menu: "알림 설정"),
                MyProfile(image: Icon.permit, menu: "이용약관")]
    }
}
