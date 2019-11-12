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
    init(status: Status) {
        self.status = status
    }
}
