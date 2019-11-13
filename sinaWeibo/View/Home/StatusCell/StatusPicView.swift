//
//  StatusPicView.swift
//  sinaWeibo
//
//  Created by Sunny on 2019/11/13.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit
import Kingfisher
let screenWidth = UIScreen.main.bounds.width
private let StatusPicViewItemMargin: CGFloat = 8
private let StatusPicViewCellId = "StatusPicViewCellId"
class StatusPicView: UICollectionView {
    
    var viewModel: StatusViewModel? {
        didSet{
            sizeToFit()
            reloadData()
        }
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return calcViewSize()
    }
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = StatusPicViewItemMargin
        layout.minimumInteritemSpacing = StatusPicViewItemMargin
        super.init(frame: .zero, collectionViewLayout: layout)
        backgroundColor = UIColor(white: 1, alpha: 0)
        dataSource = self
        register(StatusPicViewCell.self, forCellWithReuseIdentifier: StatusPicViewCellId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension StatusPicView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.thumbnailUrls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatusPicViewCellId, for: indexPath) as! StatusPicViewCell
        cell.imgURL = viewModel?.thumbnailUrls![indexPath.item]
        return cell
    }
    

}
// 计算视图大小
extension StatusPicView {
    private func calcViewSize() -> CGSize{
        let rowCount: CGFloat = 3
        let maxWidth = screenWidth - 2 * statusCellMargin
        let itemWidth = (maxWidth - 2 * StatusPicViewItemMargin) / rowCount
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        let count = viewModel?.thumbnailUrls?.count ?? 0
        if count == 0 {
            return CGSize.zero
        }
        else if count == 1 {
            return CGSize(width: 150, height: 120)
        }
        else if count == 4 {
            let w = 2 * itemWidth + StatusPicViewItemMargin
            return CGSize(width: w, height: w)
        }else {
            let row = CGFloat((count - 1) / Int(rowCount) + 1)
            let h = row * itemWidth + (row - 1) * StatusPicViewItemMargin
            let w = rowCount * itemWidth + (rowCount - 1) * StatusPicViewItemMargin
            return CGSize(width: w, height: h)
        }
    }
}

class StatusPicViewCell: UICollectionViewCell {
    var imgURL: URL? {
        didSet{
            iconView.kf.setImage(with: imgURL, placeholder: nil, options: [.forceRefresh, .keepCurrentImageWhileLoading])
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        contentView.addSubview(iconView)
        iconView.contentMode = .scaleAspectFill
        iconView.clipsToBounds = true
        iconView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView.snp.edges)
        }
        
    }
    private lazy var iconView = UIImageView()
}
