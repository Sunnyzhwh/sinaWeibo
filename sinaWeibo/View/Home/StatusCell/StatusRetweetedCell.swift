//
//  StatusRetweetedCell.swift
//  sinaWeibo
//
//  Created by Sunny on 2019/11/13.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit

class StatusRetweetedCell: StatusCell {
    
    override var viewModel: StatusViewModel? {
        didSet{
            retweetedLabel.text = viewModel?.retweetedText
            pictureView.snp.updateConstraints { (update) in
                let offset = (viewModel?.thumbnailUrls?.count)! > 0 ? statusCellMargin : 0
                update.top.equalTo(retweetedLabel.snp.bottom).offset(offset)
            }
        }
    }
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0.92, alpha: 1.0)
        return button
    }()
    private lazy var retweetedLabel = UILabel(title: "转发微博", fontSize: 14, color: UIColor.darkGray, screenInset: statusCellMargin)
    override func setupUI() {
        super.setupUI()
        
        contentView.insertSubview(backButton, belowSubview: pictureView)
        contentView.insertSubview(retweetedLabel, aboveSubview: backButton)
        
        retweetedLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backButton.snp.top).offset(statusCellMargin)
            make.left.equalTo(backButton.snp.left).offset(statusCellMargin)
        }
        
        backButton.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(statusCellMargin)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalTo(bottomView.snp.top)
        }
        pictureView.snp.makeConstraints { (make) in
            make.top.equalTo(retweetedLabel.snp.bottom).offset(statusCellMargin)
            make.left.equalTo(retweetedLabel.snp.left)
            make.width.equalTo(300)
            make.height.equalTo(90)
        }
    }
}

