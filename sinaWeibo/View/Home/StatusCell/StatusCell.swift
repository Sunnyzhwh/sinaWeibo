//
//  StatusCell.swift
//  sinaWeibo
//
//  Created by Sunny on 2019/11/12.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit

class StatusCell: UITableViewCell {
    
    var viewModel: StatusViewModel? {
        didSet{
            topView.viewModel = viewModel
            contentLabel.text = viewModel?.status.text
            bottomView.viewModel = viewModel
        }
    }
    private lazy var topView: StatusCellTopView = StatusCellTopView()
    private lazy var contentLabel = UILabel(title: "微博正文", fontSize: 15, color: UIColor.darkGray, screenInset: 1)
    private lazy var bottomView: StatusCellBottomView = StatusCellBottomView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension StatusCell {
    private func setupUI() {
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(bottomView)
        let headerView = UIView()
        headerView.backgroundColor = UIColor(white: 0.92, alpha: 1)
        contentView.addSubview(headerView)
        
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(statusCellMargin)
        }
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(statusCellMargin * 2 + statusCellIcon)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(statusCellMargin)
            make.top.equalTo(topView.snp.bottom).offset(statusCellMargin)
        }
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(statusCellMargin)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(44)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
}
