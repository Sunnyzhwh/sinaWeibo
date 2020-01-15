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
    private lazy var pullupView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.color = UIColor.lightGray
        return indicator
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserAccountViewModel.sharedUserAccount.userLogon {
            visitorView?.setInfo(imageName: nil, title: "关注一些人，回这里看看有什么消息")
            return
        }
        setTableView()
        loadData()
        // 注册点击图片通知
        NotificationCenter.default.addObserver(forName: WBStatusSelectedPhotoNotification, object: nil, queue: nil) { (notify) in
            guard let indexPath = notify.userInfo?["selectedIndexPath"] as? IndexPath else {
                return
            }
            guard let urls = notify.userInfo?["picURL"] as? [URL] else { return }
            let vc = PhotoBrowserViewController(currentIndexPath: indexPath, urls: urls)
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    deinit {
        // 注销通知
        NotificationCenter.default.removeObserver(self)
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
        if indexPath.row == statusList.statusArray.count - 1, !pullupView.isAnimating {
            pullupView.startAnimating()
            loadData()
            print("上拉刷新数据")
        }
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
        refreshControl = WBRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.tableFooterView = pullupView
    }

    @objc private func loadData() {
        refreshControl?.beginRefreshing()
        statusList.loadStatus(isPullup: pullupView.isAnimating) { (isSuccessed) in
            self.refreshControl?.endRefreshing()
            self.pullupView.stopAnimating()
            if isSuccessed {
                self.tableView.reloadData()
            } else {
                SVProgressHUD.showInfo(withStatus: "加载数据错误，请稍后再试！")
            }
        }
        
    }
}
