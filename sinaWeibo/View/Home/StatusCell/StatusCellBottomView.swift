//
//  StatusCellBottomView.swift
//  sinaWeibo
//
//  Created by Sunny on 2019/11/12.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit

class StatusCellBottomView: UIView {
    var viewModel: StatusViewModel? {
        didSet{
            
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var retweetedButton = UIButton(title: " 转发", fontSize: 12, color: UIColor.darkGray, imageName: "timeline_icon_retweet")
    private lazy var commentButton = UIButton(title: " 评论", fontSize: 12, color: UIColor.darkGray, imageName: "timeline_icon_comment")
    private lazy var likeButton = UIButton(title: " 赞", fontSize: 12, color: UIColor.darkGray, imageName: "timeline_icon_unlike")
    private lazy var seperater1 = UIView()
    private lazy var seperater2 = UIView()
}
extension StatusCellBottomView {
    private func setupUI() {
        backgroundColor = UIColor(white: 0.98, alpha: 1.0)
        addSubview(retweetedButton)
        addSubview(commentButton)
        addSubview(likeButton)
        addSubview(seperater1)
        addSubview(seperater2)
        
        retweetedButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.bottom.equalTo(self.snp.bottom)
        }
        commentButton.snp.makeConstraints { (make) in
            make.top.equalTo(retweetedButton.snp.top)
            make.left.equalTo(retweetedButton.snp.right)
            make.bottom.equalTo(retweetedButton.snp.bottom)
            make.width.equalTo(retweetedButton.snp.width)
        }
        likeButton.snp.makeConstraints { (make) in
            make.top.equalTo(retweetedButton.snp.top)
            make.left.equalTo(commentButton.snp.right)
            make.bottom.equalTo(retweetedButton.snp.bottom)
            make.width.equalTo(retweetedButton.snp.width)
            make.right.equalTo(self.snp.right)
        }
        
        let w = 0.5
        let scale = 0.4
        seperater2.backgroundColor = UIColor.lightGray
        seperater1.backgroundColor = UIColor.lightGray
        seperater1.snp.makeConstraints { (make) in
            make.centerY.equalTo(retweetedButton.snp.centerY)
            make.left.equalTo(retweetedButton.snp.right)
            make.height.equalTo(self.snp.height).multipliedBy(scale)
            make.width.equalTo(w)
        }
        seperater2.snp.makeConstraints { (make) in
            make.centerY.equalTo(commentButton.snp.centerY)
            make.left.equalTo(commentButton.snp.right)
            make.height.equalTo(self.snp.height).multipliedBy(scale)
            make.width.equalTo(w)
        }
    }
}
