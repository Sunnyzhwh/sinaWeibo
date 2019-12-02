//
//  EmoticonViewModel.swift
//  EmojiKeyboard
//
//  Created by Sunny on 2019/12/1.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit

class EmoticonManager {
    static let shared = EmoticonManager()
    lazy var packages = [EmoticonPackage]()
    private init() {
        packages.append(EmoticonPackage(dict: ["group_icon_name":"compose_emotion_table_recent","group_name_cn":"最近"]))
        let path = Bundle.main.path(forResource: "emoticons", ofType: "plist", inDirectory: "Emoticons.bundle")!
//        print(path)
        let dict = NSDictionary(contentsOfFile: path) as! [String : Any]
//        print(dict)
        // 从字典中获得ID的数组---valueforkey 直接获取字典数组中的key对应的数组
        let array = (dict["packages"] as! NSArray).value(forKey: "id")
//        print(array)
        for id in array as! [String]{
//            print(id)
            loadPlist(id: id)
        }
//        print(packages)
    }
    private func loadPlist(id: String) {
        
        let path = Bundle.main.path(forResource: "content.plist", ofType: nil, inDirectory: "Emoticons.bundle/\(id)")!
        
        let dict = NSDictionary(contentsOfFile: path) as! [String : Any]
//        print(dict)
        packages.append(EmoticonPackage(dict: dict))
    }
}
