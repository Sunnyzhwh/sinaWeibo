//
//  EmoticonPackage.swift
//  EmojiKeyboard
//
//  Created by Sunny on 2019/12/1.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit
// MARK: 表情包模型
class EmoticonPackage: NSObject {
    // 表情包所在路径
    @objc var id: String?
    // 表情包的名称显示在toolbar中
    @objc var group_name_cn: String?
    // 表情包图标
    @objc var group_icon_name: String?
    // 表情数组 - 能够保证在使用的时候，数组已经存在，可以直接追加数据
    @objc lazy var emoticons = [Emoticon]()
    
    init(dict:[String : Any]){
        super.init()
        id = dict["id"] as? String
        group_name_cn = dict["group_name_cn"] as? String
        group_icon_name = dict["group_icon_name"] as? String
        if let array = dict["emoticons"] as? [[String : Any]] {
            var index = 0
            for var d in array {
                if let png = d["png"] as? String {
                    d["png"] = "emoticonImage/" + png
                }
                emoticons.append(Emoticon(dict: d))
                // 每隔20个添加删除表情
                index += 1
                if index == 20 {
                    emoticons.append(Emoticon(isRemoved: true))
                    index = 0
                }
            }
        }
        appendIsEmpty()
    }
    private func appendIsEmpty() {
        let count = emoticons.count % 21
        if emoticons.count > 0, count == 0 {
            return
        }
//        print("\(String(describing: group_name_cn))剩余表情数量\(count)")
        // 添加空白表情
        for _ in count..<20 {
            emoticons.append(Emoticon(empty: true))
        }
        // 在最末尾添加一个删除
        emoticons.append(Emoticon(isRemoved: true))
    }
    override var description: String {
        let keys = ["id", "group_name_cn", "group_icon_name", "emoticons"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
