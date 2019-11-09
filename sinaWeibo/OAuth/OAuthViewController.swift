//
//  OAuthViewController.swift
//  sinaWeibo
//
//  Created by Sunny on 2019/11/8.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit
import WebKit
class OAuthViewController: UIViewController {
    
    
    private lazy var webView = WKWebView()
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func autoFill() {
        let js = "document.getElementById('userId').value = 'zhwh-001@163.com';" + "document.getElementById('passwd').value = 'zhwh001122';"
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    override func loadView() {
        view = webView
        title = "登录新浪微博"
        webView.navigationDelegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", style: .plain, target: self, action: #selector(autoFill))
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.load(URLRequest(url: NetWorkTools.sharedTools.oauthURL))
    }
    

   
}
extension OAuthViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let request = navigationAction.request
        if let url = request.url, url.host == "www.baidu.com" {
            print(url.query!)
            print(url)
            if let query = url.query, query.hasPrefix("code="){
                // MARK: subString 替换成String（str【index...】） from    str[..<index] to str[range] range
                let code = String(query["code=".endIndex...])
                print("用户授权")
                print("授权码是\(code)")
                UserAccountViewModel.sharedUserAccount.loadAccessToken(code: code)
            }else {
                print("取消授权")
            }
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    


}


