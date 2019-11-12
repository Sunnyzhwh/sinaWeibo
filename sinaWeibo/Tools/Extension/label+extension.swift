//
//  label+extension.swift
//  sinaWeibo
//
//  Created by Sunny on 2019/11/4.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit
extension UILabel {
    convenience init(title: String, fontSize: CGFloat = 14.0, color: UIColor = UIColor.darkGray, screenInset: CGFloat = 0) {
        self.init()
        text = title
        textColor = color
        font = UIFont.systemFont(ofSize: fontSize)
        numberOfLines = 0
        if screenInset == 0 {
            textAlignment = .center
        }else {
            textAlignment = .left
            preferredMaxLayoutWidth = UIScreen.main.bounds.width - 2 * statusCellMargin
        }
    }
}
