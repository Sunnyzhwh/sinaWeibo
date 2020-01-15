//
//  uicolor.swift
//  sinaWeibo
//
//  Created by Sunny on 2020/1/15.
//  Copyright © 2020年 Sunny. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var randomColor: UIColor {
        let r = CGFloat(Double(arc4random_uniform(255))/255.0)
        let g = CGFloat(Double(arc4random_uniform(255))/255.0)
        let b = CGFloat(Double(arc4random_uniform(255))/255.0)
        let color = UIColor(red: r, green: g, blue: b, alpha: 1.0)
        return color
    }
}
