//
//  TabBarController.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/13.
//

import UIKit

final class TabBarController: UITabBarController, UITabBarControllerDelegate {

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        configureTabBarViewController()
    }
    
    // MARK: - Custom Method
    
    private func setupDelegate() {
        delegate = self
    }

    private func configureTabBarViewController() {
        UITabBar.appearance().backgroundColor = .white
        tabBar.tintColor = .black
        tabBar.barTintColor = .white
        tabBar.isTranslucent = false
        
        let firstTabController = HomeViewController()
        let secondTabController = BookmarkViewController()
        let thirdTabController = SettingViewController()
        
        firstTabController.tabBarItem = UITabBarItem(
            title: "홈",
            image: Icon.TabBar.unselectedMap,
            selectedImage: Icon.TabBar.map)
                
        secondTabController.tabBarItem = UITabBarItem(
            title: "책갈피",
            image: Icon.TabBar.unselectedBookmark,
            selectedImage: Icon.TabBar.bookmark)
        
        thirdTabController.tabBarItem = UITabBarItem(
            title: "설정",
            image: Icon.TabBar.unselectedSetting,
            selectedImage: Icon.TabBar.setting)
        
        self.viewControllers = [firstTabController, secondTabController, thirdTabController]
    }
}
