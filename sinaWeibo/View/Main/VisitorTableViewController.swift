//
//  VisitorTableViewController.swift
//  sinaWeibo
//
//  Created by Sunny on 2019/11/4.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit

class VisitorTableViewController: UITableViewController {

    private var userLogon = UserAccountViewModel.sharedUserAccount.userLogon
    var visitorView: VisitorView?
    override func loadView() {
        
        userLogon ? super.loadView() : setupVisitorView()
    }
    private func setupVisitorView() {
        visitorView = VisitorView()
        print("visitor")
        view = visitorView
        visitorView?.registerButtion.addTarget(self, action: #selector(visitorDidReg), for: .touchUpInside)
        visitorView?.loginButtion.addTarget(self, action: #selector(visitorDidLogin), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(visitorDidReg))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(visitorDidLogin))
    }

}
extension VisitorTableViewController {
    @objc func visitorDidReg() {
        print("注册")
    }
    
    @objc func visitorDidLogin() {
        print("登录")
        let vc = OAuthViewController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    
}
