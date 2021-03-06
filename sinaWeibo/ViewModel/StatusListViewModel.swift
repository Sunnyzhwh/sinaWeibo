//
//  StatusListViewModel.swift
//  sinaWeibo
//
//  Created by Sunny on 2019/11/12.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit
import Kingfisher
/// 获取网络数据，字典转模型
class StatusListViewModel {
    lazy var statusArray = [StatusViewModel]()
    func loadStatus(isPullup: Bool, finished: @escaping (_ isSuccessed: Bool) -> ()) {
        /// 下拉刷新数组中第一条微博的ID
        let sinceId = isPullup ? 0 : (statusArray.first?.status.id ?? 0)
        /// 上拉刷新数组中最后一条微博的ID
        let maxId = isPullup ? (statusArray.last?.status.id ?? 0) : 0
        NetWorkTools.sharedTools.fetchStatus(since_id: sinceId, max_id: maxId) { (result) in
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
            var datalist = [StatusViewModel]()
            for dict in dataArray {
                datalist.append(StatusViewModel(status: Status(dict: dict)))
            }
            print("刷新到\(datalist.count)条微博")
            /// 拼接微博数据
            /// 判断是否上拉刷新
            if maxId > 0 {
                self.statusArray += datalist
            }else {
                self.statusArray = datalist + self.statusArray
            }
            self.cacheSingleImage(dataList: self.statusArray, finished: finished)
        }
    }
    private func cacheSingleImage(dataList: [StatusViewModel], finished: @escaping (_ isSuccessed: Bool) -> ()) {
        /// 设置调度组初始化
        let group = DispatchGroup()
        var dataLength = 0
        for vm in dataList {
            if vm.thumbnailUrls?.count != 1{
                continue
            }
            let url = vm.thumbnailUrls![0]
            
            print("开始缓存图像\(url)")
            /// 入组，监听后续的closure
            group.enter()
            KingfisherManager.shared.retrieveImage(with: url, options: [.forceRefresh], progressBlock: nil) { (result) in
                switch result {
                case .success(let value):
                    let data = value.image.pngData()
                    dataLength += data!.count
                    print(value.cacheType)
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    /// 出组
                    group.leave()
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            }
        }
        /// 监听调度组完成
        group.notify(queue: DispatchQueue.main) {
            print("缓存完成\(dataLength / 1024) K")
            finished(true)
        }
    }
}

