//
//  StatusViewModel.swift
//  sinaWeibo
//
//  Created by Sunny on 2019/11/12.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit
/// 实现单条微博的业务逻辑
class StatusViewModel {
    var status: Status
    /// 表格的可重用标识符
    var cellId: String {
        return status.retweeted_status != nil ? statusRetweetedCellId : statusCellNormalId
    }
    /// 缓存行高
    lazy var rowHeight: CGFloat = {
        var cell: StatusCell
//        print("计算行高_\(self.status.text ?? "-")")
        if status.retweeted_status != nil {
            cell = StatusRetweetedCell(style: .default, reuseIdentifier: statusRetweetedCellId)
        }else {
            cell = StatusNormalCell(style: .default, reuseIdentifier: statusCellNormalId)
        }
        
        return cell.rowHeight(vm: self)
    }()
    var userProfileUrl: URL {
        return URL(string: status.user?.profile_image_url ?? "")!
    }
    var memberImage: UIImage? {
        if (status.user?.mbrank)! > 0 && (status.user?.mbrank)! < 7 {
            return UIImage(named: "common_icon_membership_level\(status.user!.mbrank)")
        }
        return nil
    }
    var vipImage: UIImage? {
        /// 认证类型： -1 没有认证，0 认证用户，2、3、5企业认证， 220 达人
        switch (status.user?.verified_type ?? -1) {
        case 220: return UIImage(named: "avatar_grassroot")
        case 2,3,5: return UIImage(named: "avatar_enterprise_vip")
        case 0: return UIImage(named: "avatar_vip")
        default: return nil
        }
    }
    
    var retweetedText: String? {
        guard let s = status.retweeted_status else {
            return nil
        }
        return "@" + (s.user?.screen_name)!  + ":" + s.text!
    }
    var thumbnailUrls: [URL]?
    init(status: Status) {
        self.status = status
        
        if let urls = status.retweeted_status?.pic_urls ?? status.pic_urls {
            thumbnailUrls = [URL]()
            for dict in urls {
                let url = URL(string: dict["thumbnail_pic"]!)
                thumbnailUrls?.append(url!)
            }
        }
    }
}
