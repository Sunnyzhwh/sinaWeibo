//
//  UIBarButtonItem+Extension.swift
//  sinaWeibo
//
//  Created by Sunny on 2019/12/3.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit
/// 便利初始化
extension UIBarButtonItem {
    convenience init(imageName: String,replace destination : String, with replacement : String, target: Any?) {
        let button = UIButton(imageName: imageName, backgroundImageName: nil)
        // 获取按钮对应的响应方法字符串
        let act = imageName.replacingOccurrences(of: destination, with: replacement)
        button.addTarget(target, action: Selector(act), for: .touchUpInside)
        self.init(customView: button)
    }
}
