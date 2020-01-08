//
//  UIImage+Extension.swift
//  sinaWeibo
//
//  Created by Sunny on 2020/1/4.
//  Copyright © 2020 Sunny. All rights reserved.
//

import UIKit

extension UIImage {
    /// 将图像缩放至指定宽度
    func scaleToWidth(width: CGFloat) -> UIImage {
        
        if width > size.width {
            return self
        }
        let height = size.height * width / size.width
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        // 使用核心绘图绘制新的图像
        // 1、开启上下文
        UIGraphicsBeginImageContext(rect.size)
        // 2、绘图 - 在指定区域绘制
        self.draw(in: rect)
        // 3、取结果
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        // 4、关闭上下文
        UIGraphicsEndImageContext()
        // 5、返回结果
        return result
    }
}
