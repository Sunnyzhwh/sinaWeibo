//
//  MainViewController.swift
//  sinaWeibo
//
//  Created by Sunny on 2019/11/4.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    // MARK: 监听按钮点击
    @objc private func composedClicked() {
        print("--")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addChildren()
        setupComposedButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar.bringSubviewToFront(compsedButton)
    }
    private lazy var compsedButton: UIButton = UIButton(
        imageName: "tabbar_compose_icon_add",
        backgroundImageName: "tabbar_compose_button"
    )

}

// MARK: 设置UI界面
extension MainViewController {
    private func setupComposedButton() {
        tabBar.addSubview(compsedButton)
        // adjust position
        let count = children.count
        let itemWidth = tabBar.bounds.width / CGFloat(count)
        compsedButton.frame = tabBar.bounds.insetBy(dx: itemWidth * 2 - 2, dy: 0)
        compsedButton.addTarget(self, action: #selector(composedClicked), for: .touchUpInside)
    }
    /// 添加所有控制器
    private func addChildren() {
        addChild(vc: HomeTableViewController(), title: "首页", imageName: "tabbar_home")
        addChild(vc: MessageTableViewController(), title: "消息", imageName: "tabbar_message_center")
        addChild(UIViewController())
        addChild(vc: DiscoverTableViewController(), title: "发现", imageName: "tabbar_discover")
        addChild(vc: ProfileTableViewController(), title: "我", imageName: "tabbar_profile")
    }
    /// 添加控制器
    private func addChild(vc: UIViewController, title: String, imageName: String) {
        
        // 设置标题，由内至外 （view -》 Navigation -》 TabBar）
        vc.title = title
        vc.tabBarItem.image = UIImage(named: imageName)
        let nav = UINavigationController(rootViewController: vc)
//        nav.tabBarItem.title = title
        addChild(nav)
    }
}


