//
//  EmoticonAttachment.swift
//  EmojiKeyboard
//
//  Created by Sunny on 2019/12/2.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit
/// 获取文本附件
class EmoticonAttachment: NSTextAttachment {
    var emoticon: Emoticon
    init(emotion: Emoticon) {
        self.emoticon = emotion
        super.init(data: nil, ofType: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 获取一个表情图片的文本附件
    func imageText(font: UIFont) -> NSAttributedString {
        image = UIImage(named: emoticon.imagePath)
        let lineHeight = font.lineHeight
        bounds = CGRect(x: 0, y: -4, width: lineHeight, height: lineHeight)
        // 获取图片文本
        let imageText = NSMutableAttributedString(attributedString: NSAttributedString(attachment: self))
        // 添加字体，在UIkit.framework 的第一个头文件
        imageText.addAttribute(NSAttributedString.Key.font, value: font, range: NSRange(location: 0, length: 1))
        return imageText
    }
}
