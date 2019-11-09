//
//  UserAccountViewModel.swift
//  sinaWeibo
//
//  Created by Sunny on 2019/11/9.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit

class UserAccountModel: NSObject, Codable {

    
    @objc var access_token: String?
    @objc var expires_in: TimeInterval = 0 {
        didSet {
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    var expiresDate: Date?
    @objc var uid: String?
    var screen_name: String?
    var avatar_large: String?
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }

    init(dict: [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    init?(json: Data) {
        super.init()
        if let newValue = try? JSONDecoder().decode(UserAccountModel.self, from: json) {
            self.access_token = newValue.access_token
            self.expires_in = newValue.expires_in
            self.expiresDate = newValue.expiresDate
            self.uid = newValue.uid
            self.screen_name = newValue.screen_name
            self.avatar_large = newValue.avatar_large
        }else {
            return nil
        }
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    override var description: String {
        let keys = ["access_token","expires_in","uid"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
