//
//  NetWorkTools.swift
//  sinaWeibo
//
//  Created by Sunny on 2019/11/8.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit
import Alamofire

class NetWorkTools {
    private let appKey = "4281004451"
    private let appSecret = "922e80541cd019fc85f72306aa9b7324"
    private let redirectUrl = "http://www.baidu.com"
    // MARK: 定义回调闭包
//    typealias dataRequestCallBack = @escaping (_ result: Any) -> ()
    static let sharedTools = NetWorkTools()
    
    private var tokenDict: [String : Any]? {
        if let token = UserAccountViewModel.sharedUserAccount.accessToken {
            return ["access_token" : token]
        }
        return nil
    }
    // MARK: 获取token
    func loadAccessToken(code: String, finished: @escaping (_ result: Any) -> ()) {
        let url = "https://api.weibo.com/oauth2/access_token"
        let parameters = ["client_id":appKey,
                          "client_secret":appSecret,
                          "grant_type":"authorization_code",
                          "code":code,
                          "redirect_uri":redirectUrl]
        requestData(url: url, amethod: .post, parameters: parameters, finished: finished)
    }
    
}
// MARK: 加载微博相关数据
extension NetWorkTools {
    /// 加载授权用户的最新微博
    /// -see[https://open.weibo.com/wiki/2/statuses/home_timeline](https://open.weibo.com/wiki/2/statuses/home_timeline)
    func fetchStatus(finished: @escaping (_ result: Any) -> ()) {
        let url = "https://api.weibo.com/2/statuses/home_timeline.json"
        guard let parameters = tokenDict else {
            print("token无效")
            return
        }
        requestData(url: url, amethod: .get, parameters: parameters, finished: finished)
    }
}
extension NetWorkTools {
    /// -see[https://open.weibo.com/wiki/2/users/show](https://open.weibo.com/wiki/2/users/show)
    func loadUserInfo(uid: String, finished: @escaping (_ result: Any) -> ()) {
        let url = "https://api.weibo.com/2/users/show.json"
        guard var parameters = tokenDict else {
            print("token无效")
            return
        }
        parameters["uid"] = uid
        print(parameters)
        requestData(url: url, amethod: .get, parameters: parameters, finished: finished)
    }
}

extension NetWorkTools {
    ///OAuth 授权URL
    /// -see:[https://open.weibo.com/wiki/Oauth2/authorize](https://open.weibo.com/wiki/Oauth2/authorize)
    var oauthURL: URL {
        let url = "https://api.weibo.com/oauth2/authorize?client_id=\(appKey)&redirect_uri=\(redirectUrl)"
        return URL(string: url)!
    }
}

extension NetWorkTools {
    // MARK: 获取网络请求
    private func requestData(url: String, amethod: Alamofire.HTTPMethod, parameters: [String : Any]? = nil, finished: @escaping (_ result: Any) -> ()) {
        Alamofire.request(url, method: amethod, parameters: parameters).responseJSON { (response) in
            guard let result = response.result.value else {
                print(response.result.error ?? "---")
                return }
            finished(result)
        }
    }
}


// https://api.weibo.com/oauth2/authorize?client_id=4281004451&redirect_uri=http://www.baidu.com
//https://api.weibo.com/2/statuses/home_timeline.json?access_token=2.00Vp5LyCtoeifE981326f6c7GSuL2D
