//
//  StatusNormalCell.swift
//  sinaWeibo
//
//  Created by Sunny on 2019/11/14.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit

class StatusNormalCell: StatusCell {

    override var viewModel: StatusViewModel? {
        didSet{
            pictureView.snp.updateConstraints { (update) in

                let offset = (viewModel?.thumbnailUrls?.count)! > 0 ? statusCellMargin : 0
                update.top.equalTo(contentLabel.snp.bottom).offset(offset)
            }
        }
    }
    override func setupUI() {
        super.setupUI()
        pictureView.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom)
            make.left.equalTo(contentLabel.snp.left)
            make.width.equalTo(300)
            make.height.equalTo(90)
        }
    }
}
