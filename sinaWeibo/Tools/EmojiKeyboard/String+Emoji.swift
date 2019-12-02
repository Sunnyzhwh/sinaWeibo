//
//  String+Emoji.swift
//  EmojiKeyboard
//
//  Created by Sunny on 2019/12/2.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import Foundation
extension String {
    /// 返回当前字符串中16进制对应的Emoji字符串
    var emoji: String {
        // 文本扫描器 - 扫描指定的字符串
        let scanner = Scanner(string: self)
        // Unicode 的值
        var value: UInt32 = 0
        scanner.scanHexInt32(&value)
        // 转换Unicode字符
        let chr = Character(UnicodeScalar(value)!)
        return "\(chr)"
    }
}
