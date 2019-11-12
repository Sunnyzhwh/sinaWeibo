//
//  StatusCellTopView.swift
//  sinaWeibo
//
//  Created by Sunny on 2019/11/12.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit

let statusCellMargin: CGFloat = 12
let statusCellIcon: CGFloat = 36
class StatusCellTopView: UIView {
    var viewModel: StatusViewModel? {
        didSet{
            screenNameLabel.text = viewModel?.status.user?.screen_name
            iconView.kf.setImage(with: viewModel?.userProfileUrl, placeholder: UIImage(named: "avatar_default_big"))
            memberIconView.image = viewModel?.memberImage
            vipIconView.image = viewModel?.vipImage
            timeLabel.text = "刚刚"//viewModel?.status.created_at
            sourceLabel.text = "iPhone客户端"//viewModel?.status.source
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var iconView = UIImageView(image: UIImage(named: "avatar_default_big"))
    private lazy var screenNameLabel = UILabel(title: "张三", fontSize: 14, color: UIColor.darkGray)
    private lazy var memberIconView = UIImageView(image: UIImage(named: "common_icon_membership_level1"))
    private lazy var vipIconView = UIImageView(image: UIImage(named: "avatar_vip"))
    private lazy var timeLabel = UILabel(title: "现在", fontSize: 11, color: UIColor.orange)
    private lazy var sourceLabel = UILabel(title: "来源", fontSize: 11)
}
extension StatusCellTopView {
    private func setupUI() {
        backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        iconView.layer.cornerRadius = 18
        iconView.layer.masksToBounds = true
        addSubview(iconView)
        addSubview(screenNameLabel)
        addSubview(memberIconView)
        addSubview(vipIconView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        
        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(statusCellMargin)
            make.left.equalTo(self.snp.left).offset(statusCellMargin)
            make.size.equalTo(statusCellIcon)
        }
        screenNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(statusCellMargin)
            make.left.equalTo(iconView.snp.right).offset(statusCellMargin)
        }
        memberIconView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(statusCellMargin)
            make.left.equalTo(screenNameLabel.snp.right).offset(statusCellMargin)
            
        }
        vipIconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(iconView.snp.centerX).offset(statusCellIcon * sqrt(2) / 4)
            make.centerY.equalTo(iconView.snp.centerY).offset(statusCellIcon * sqrt(2) / 4)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(statusCellMargin)
            make.bottom.equalTo(iconView.snp.bottom)
        }
        sourceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp.right).offset(statusCellMargin)
            make.bottom.equalTo(iconView.snp.bottom)
        }
    }
}
