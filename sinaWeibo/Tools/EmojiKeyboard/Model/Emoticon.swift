//
//  Emoticon.swift
//  EmojiKeyboard
//
//  Created by Sunny on 2019/12/1.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit
/// 表情模型
class Emoticon: NSObject {
    // 发送给服务器的表情字符串
    @objc var chs: String?
    // 在本地显示的图片名称 + 部分路径
    @objc var png: String?
    var imagePath: String {
        if png == nil {
            return ""
        }
        return Bundle.main.bundlePath + "/Emoticons.bundle/" + png!
    }
    // Emoji的字符串编码
    @objc var code: String? {
        didSet{
            emoji = code?.emoji
        }
    }
    var emoji: String?
    @objc var isRemoved = false
    init(isRemoved: Bool){
        self.isRemoved = isRemoved
    }
    @objc var isEmpty = false
    init(empty: Bool){
        self.isEmpty = empty
    }
    init(dict: [String : Any]){
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    override var description: String {
        let keys = ["chs", "png", "code","isRemoved","isEmpty"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
