//
//  HomeTableViewController.swift
//  sinaWeibo
//
//  Created by Sunny on 2019/11/4.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit
import SVProgressHUD
let statusCellNormalId = "statusCellNormalId"
let statusRetweetedCellId = "statusRetweetedCellId"
class HomeTableViewController: VisitorTableViewController {
    private lazy var statusList = StatusListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserAccountViewModel.sharedUserAccount.userLogon {
            visitorView?.setInfo(imageName: nil, title: "关注一些人，回这里看看有什么消息")
        }
        setTableView()
        loadData()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusList.statusArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = statusList.statusArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: vm.cellId, for: indexPath) as! StatusCell
        cell.viewModel = vm
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        print("计算行高\(indexPath)")
        let vm = statusList.statusArray[indexPath.row]

        return vm.rowHeight
    }
}
extension HomeTableViewController {
    private func setTableView() {
        tableView.register(StatusRetweetedCell.self, forCellReuseIdentifier: statusRetweetedCellId)
        tableView.register(StatusNormalCell.self, forCellReuseIdentifier: statusCellNormalId)
        ///使用自动计算行高，需要指定一个自上由下的约束

        tableView.estimatedRowHeight = 400
        tableView.separatorStyle = .none
    }
    private func loadData() {
        statusList.loadStatus { (isSuccessed) in
            if isSuccessed {
                self.tableView.reloadData()
            } else {
                SVProgressHUD.showInfo(withStatus: "加载数据错误，请稍后再试！")
            }
        }
        
    }
}
