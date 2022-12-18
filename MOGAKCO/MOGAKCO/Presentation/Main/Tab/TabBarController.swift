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
        tabBar.tintColor = Color.green
        tabBar.barTintColor = .white
        tabBar.isTranslucent = false
        
        let firstTabController = HomeViewController(HomeViewModel())
        let secondTabController = ShopViewController()
        let fourthTabController = MyViewController(MyViewModel())
        
        firstTabController.tabBarItem = UITabBarItem(
            title: "홈",
            image: Icon.homeInactive,
            selectedImage: Icon.home)
                
        secondTabController.tabBarItem = UITabBarItem(
            title: "새싹샵",
            image: Icon.shopInactive,
            selectedImage: Icon.shop)
        
        fourthTabController.tabBarItem = UITabBarItem(
            title: "내정보",
            image: Icon.myInactive,
            selectedImage: Icon.my)
        
        self.viewControllers = [firstTabController,
                                secondTabController,
                                fourthTabController]
    }
}
