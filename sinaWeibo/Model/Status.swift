//
//  Status.swift
//  sinaWeibo
//
//  Created by Sunny on 2019/11/12.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit

class Status: NSObject {
    @objc var id: Int = 0
    @objc var text: String?
    @objc var created_at: String?
    @objc var source: String?
    @objc var user: User?
    /// 缩略图配图数组 key： thumbnail_pic
    @objc var pic_urls: [[String : String]]?
    /// 被转发的原微博信息字段
    @objc var retweeted_status: Status?
    init(dict: [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        // 处理字典嵌套
        if key == "user" {
            if let dict = value as? [String : Any] {
                user = User(dict: dict)
            }
            return
        }
        if key == "retweeted_status" {
            if let dict = value as? [String : Any] {
                retweeted_status = Status(dict: dict)
//                print(retweeted_status as Any)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String){}
    
    override var description: String {
        let keys = ["id", "text", "created_at", "source", "user", "pic_urls", "retweeted_status"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
