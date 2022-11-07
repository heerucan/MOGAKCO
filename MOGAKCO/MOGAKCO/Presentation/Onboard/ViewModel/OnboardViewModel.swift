//
//  OnboardViewModel.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import UIKit

import RxSwift

final class OnboardViewModel {
    let onboardList = Observable.of([
        Onboard(title: "위치 기반으로 빠르게\n주위 친구를 확인", image: Icon.onboarding1),
        Onboard(title: "스터디를 원하는 친구를\n찾을 수 있어요", image: Icon.onboarding2),
        Onboard(title: "SeSAC Study", image: Icon.onboarding3)
    ])
}
