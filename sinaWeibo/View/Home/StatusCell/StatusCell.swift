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
            pictureView.viewModel = viewModel
            pictureView.snp.updateConstraints { (update) in
                update.width.equalTo(pictureView.bounds.width)
                update.height.equalTo(pictureView.bounds.height)
//                let offset = (viewModel?.status.pic_urls?.count)! > 0 ? statusCellMargin : 0
//                update.top.equalTo(contentLabel.snp.bottom).offset(offset)
            }
//            print(viewModel?.status as Any)
            bottomView.viewModel = viewModel
        }
    }
    func rowHeight(vm: StatusViewModel) -> CGFloat {
        viewModel = vm
        /// 强制更新所有约束 -> 所有控件的frame都会重新计算
        contentView.layoutIfNeeded()
        
        return bottomView.frame.maxY
    }
    private lazy var topView: StatusCellTopView = StatusCellTopView()
    lazy var contentLabel = UILabel(title: "微博正文", fontSize: 15, color: UIColor.darkGray, screenInset: 1)
    lazy var pictureView = StatusPicView()
    lazy var bottomView: StatusCellBottomView = StatusCellBottomView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        //选中cell的显示样式
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: 子类继承父类方法，不能写在extension里面，想要子类继承的方法必须写在类声明中，子类继承方法也必须在类声明中！！！
    func setupUI() {
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
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
            make.top.equalTo(pictureView.snp.bottom).offset(statusCellMargin)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(44)
            //            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
}
