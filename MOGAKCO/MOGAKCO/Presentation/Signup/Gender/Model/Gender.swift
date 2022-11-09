//
//  Gender.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/10.
//

import UIKit

struct Gender: Hashable {
    let image: UIImage?
    let text: String
}

struct GenderData {
    var list = [Gender(image: Icon.man, text: "남자"), Gender(image: Icon.woman, text: "여자")]
}
