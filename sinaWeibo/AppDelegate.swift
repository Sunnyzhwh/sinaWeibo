//
//  AppDelegate.swift
//  sinaWeibo
//
//  Created by Sunny on 2019/11/4.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupAppearance()
        print(UserAccountViewModel.sharedUserAccount)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.black
        window?.rootViewController = defaultRootViewController
        window?.makeKeyAndVisible()
//        print(isNewVersion)
        // MARK: 监听通知 需要扩展notification.name为自定义通知名
        NotificationCenter.default.addObserver(
            forName: WBSwitchRootViewControllerNotification,
            object: nil,                                            //nil--监听任何对象
            queue: nil                                              //nil为主线程
            ) { [weak self] (notification) in
                print(notification)
                let vc = notification.object != nil ? WelcomeViewController() : MainViewController()
                self?.window?.rootViewController = vc
        }
        
        return true
    }
    // MARK: 注销通知
    deinit {
        NotificationCenter.default.removeObserver(self, name: WBSwitchRootViewControllerNotification, object: nil)
    }
    
    private func setupAppearance() {
        UINavigationBar.appearance().tintColor = WBApprearanceTintColor
        UITabBar.appearance().tintColor = WBApprearanceTintColor
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
extension AppDelegate {
    /// 程序启动时根视图控制器
    private var defaultRootViewController: UIViewController {
        // 1.判断是否登录
        if UserAccountViewModel.sharedUserAccount.userLogon {
            return isNewVersion ? NewfeatureViewController() : WelcomeViewController()
        }
        // 2.没有登录返回主控制器
        return MainViewController()
    }
    
    private var isNewVersion: Bool {
//        print(Bundle.main.infoDictionary ?? "--")
        // MARK: 获取当前版本号
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let version = Double(currentVersion)!
        print("当前版本 \(version)")
        // MARK: 获取之前版本号
        let sandBoxVersionKey = "sandBoxVersionKey"
        let sandVersion = UserDefaults.standard.double(forKey: sandBoxVersionKey)
        print("之前版本 \(sandVersion)")
        // MARK: 保存当前版本号到用户设置
        UserDefaults.standard.set(version, forKey: sandBoxVersionKey)
        return version > sandVersion
    }
}
//CFBundleShortVersionString plist文件的版本号键名
