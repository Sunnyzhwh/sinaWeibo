//
//  UserAccountViewModel.swift
//  sinaWeibo
//
//  Created by Sunny on 2019/11/9.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import Foundation
class UserAccountViewModel {
    // MARK: 解决避免重复从沙盒中加载json文件，提高效率，让access token便于访问
    static var sharedUserAccount = UserAccountViewModel()
    var account: UserAccountModel?
    var accessToken: String? {
        if !isExpeired {
            return account?.access_token
        }
        return nil
    }
    var userLogon: Bool {
        return account?.access_token != nil && !isExpeired
    }
    var avatarUrl: URL? {
        return URL(string: account?.avatar_large ?? "")
    }
    private var fileUrl: URL? {
        return try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("userInfo.plist")
    }
    private var isExpeired: Bool {
        if account?.expiresDate?.compare(Date()) == ComparisonResult.orderedDescending {
            return false
        }
        return true
    }
    private init() {
        if let plistData = try? Data(contentsOf: fileUrl!) {
            account = UserAccountModel(plist: plistData)
        }
//        判断口令过期测试语句
//        account?.expiresDate = Date(timeIntervalSinceNow: -3000)
        if isExpeired {
            print("口令过期，请重新登录")
            account = nil
        }
        print(account as Any)
    }
}
extension UserAccountViewModel {
    func loadAccessToken(code: String, finished: @escaping () -> ()) {
        NetWorkTools.sharedTools.loadAccessToken(code: code) { result in
            print(result)
            
            self.account = UserAccountModel(dict: result as! [String : Any])
//            print(self.account!)
//            print(self.account!.expiresDate!)
            self.loadUserInfo(account: self.account!, finished: finished)
        }
    }
    private func loadUserInfo(account: UserAccountModel, finished: @escaping () -> ()) {
        NetWorkTools.sharedTools.loadUserInfo(uid: account.uid!) { (result) in
            print(result)
            if let dict = result as? [String : Any] {
                account.screen_name = dict["screen_name"] as? String
                account.avatar_large = dict["avatar_large"] as? String
                print(account.screen_name!)
                print(account.avatar_large!)
                if let plistData = account.plist {
                    do {
                        try plistData.write(to: self.fileUrl!)
                        print("保存成功\(self.fileUrl!)")
                        finished()
                    }catch let error {
                        print("不能保存\(error)")
                    }
                }
            }
        }
    }
}
