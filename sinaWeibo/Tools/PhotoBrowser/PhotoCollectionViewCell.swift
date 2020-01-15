//
//  PhotoCollectionViewCell.swift
//  sinaWeibo
//
//  Created by Sunny on 2020/1/15.
//  Copyright © 2020年 Sunny. All rights reserved.
//

import UIKit
import Kingfisher
@objc protocol PhotoBrowserDelegate {
    func tapOne(cell: PhotoCollectionViewCell)
    func longPress(cell: PhotoCollectionViewCell)
}
class PhotoCollectionViewCell: UICollectionViewCell {
    weak var gestureDelegate: PhotoBrowserDelegate?
    @objc func tap(){
        print("tap")
        gestureDelegate?.tapOne(cell: self)
    }
    @objc func long(){
        print("long")
    }
    var imageURL: URL? {
        didSet{
            // 从磁盘加载图片
            if let key = imageURL?.absoluteString{
                let tempImage = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: key)
                imageView.center = scrollView.center
                imageView.kf.setImage(with: bmiddleURL(url: imageURL!), placeholder: tempImage, options: nil, progressBlock: nil) {
                    result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                        self.setImagePosition(image: value.image)
                        
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                    }
                    
                }
                
            }
            
        }
    }
    private func setImagePosition(image: UIImage) {
        let size = self.displaySize(image: image)
        // 判断图片高度
        if size.height < scrollView.bounds.height {
            // 上下居中显示
            let y = (scrollView.bounds.height - size.height) * 0.5
            imageView.frame = CGRect(x: 0, y: y, width: size.width, height: size.height)
        }else {
            imageView.frame = CGRect(origin: CGPoint.zero, size: size)
            scrollView.contentSize = size
        }
    }
    private func bmiddleURL(url: URL) -> URL {
        let urlString = url.absoluteString
        let bimiddleString = urlString.replacingOccurrences(of: "/thumbnail/", with: "/bmiddle/")
        return URL(string: bimiddleString)!
    }
    private func displaySize(image: UIImage) -> CGSize {
        let w = scrollView.bounds.width
        let h = image.size.height * w / image.size.width
        return CGSize(width: w, height: h)
    }
    override init(frame: CGRect) {

        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        contentView.addSubview(scrollView)
        scrollView.frame = bounds
        scrollView.addSubview(imageView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        let longPressG = UILongPressGestureRecognizer(target: self, action: #selector(long))
        imageView.addGestureRecognizer(tapGesture)
        imageView.addGestureRecognizer(longPressG)
        imageView.isUserInteractionEnabled = true
    }
    private lazy var scrollView = UIScrollView()
    private lazy var imageView = UIImageView()
}
