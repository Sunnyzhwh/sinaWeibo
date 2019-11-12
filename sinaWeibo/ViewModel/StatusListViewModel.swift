//
//  StatusListViewModel.swift
//  sinaWeibo
//
//  Created by Sunny on 2019/11/12.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit
/// 获取网络数据，字典转模型
class StatusListViewModel {
    lazy var statusArray = [StatusViewModel]()
    func loadStatus(finished: @escaping (_ isSuccessed: Bool) -> ()) {
        NetWorkTools.sharedTools.fetchStatus { (result) in
//            if let data = result as? [String : Any] {
//                if let array = data["statuses"] as? [[String : Any]] {
//                    for dict in array {
//                        self.statusArray.append(Status(dict: dict))
//                    }
//                    self.tableView.reloadData()
//                }
//            }
            guard let data = result as? [String : Any] else {
                print("数据出错")
                finished(false)
                return
            }
            guard let dataArray = data["statuses"] as? [[String : Any]] else { return }
            for dict in dataArray {
                self.statusArray.append(StatusViewModel(status: Status(dict: dict)))
            }
            finished(true)
        }
    }
}
