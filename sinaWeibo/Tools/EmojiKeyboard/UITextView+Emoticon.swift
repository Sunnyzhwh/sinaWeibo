//
//  UITextView+Emoticon.swift
//  EmojiKeyboard
//
//  Created by Sunny on 2019/12/2.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit

extension UITextView {
    
    /// 获取完整表情文字提交所需的字符串
    var submitContext: String {
        //        print(textView.attributedText!)
        let attrtext = attributedText!
        // 遍历String
        var finalStr = String()
        attrtext.enumerateAttributes(in: NSRange(location: 0, length: attrtext.length), options: []) { (dict, range, _) in
            //            print("--")
            //            print(dict)
            //            print(range)
            // 调试结论，如果字典中包含NSAttachment ，说明是图片
            // 否则是字符串,可以通过range获得
            // 定义字典的key用来访问字典的值
            let dicStr = NSAttributedString.Key.init(rawValue: "NSAttachment")
            
            if let value = dict[dicStr] as? EmoticonAttachment{
                //                print("pic\(value.emoticon.chs!)")
                finalStr.append(value.emoticon.chs!)
            }else {
                // 通过下标获取所需的字符串
                let str = (attrtext.string as NSString).substring(with: range)
                //                print(str)
                finalStr.append(str)
            }
            
        }
        return finalStr
    }
    func selectedEmoji(em: Emoticon){
        // 1. 处理空白表情
        if em.isEmpty {
            return
        }
        // 2. 处理删除按钮
        if em.isRemoved {
            deleteBackward()
            return
        }
        // 3. 处理emoji
        if let emoji = em.emoji {
            replace(selectedTextRange!, withText: emoji)
            addRecentEmotion(em: em)
            return
        }
        // 4.处理图片表情包
        insertEmoji(em: em)
        // 5.通知代理文本变化了
        delegate?.textViewDidChange?(self)
    }
    private func insertEmoji(em: Emoticon) {
//        let attachment = EmoticonAttachment(emotion: em)
//        attachment.image = UIImage(named: em.imagePath)
//        let lineHeight = font!.lineHeight
//        attachment.bounds = CGRect(x: 0, y: -4, width: lineHeight, height: lineHeight)
//        // 获取图片文本
//        let imageText = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
//        // 添加字体，在UIkit.framework 的第一个头文件
//        imageText.addAttribute(NSAttributedString.Key.font, value: font!, range: NSRange(location: 0, length: 1))
        // 记录textview当前的text，转换成可变文本
        let strM = NSMutableAttributedString(attributedString: attributedText)
        // 记录光标位置
        let selectedRangeM = selectedRange
        let imageText = EmoticonAttachment(emotion: em).imageText(font: font!)
        strM.replaceCharacters(in: selectedRangeM, with: imageText)
        attributedText = strM
        selectedRange = NSRange(location: selectedRangeM.location + 1, length: 0)
        addRecentEmotion(em: em)
        return
    }
    private func addRecentEmotion(em: Emoticon){
        let packages = EmoticonManager.shared.packages[0]
        let unique = packages.emoticons.contains(em)
        if unique {
            let i = packages.emoticons.index(of: em)!
            packages.emoticons.remove(at: i)
            packages.emoticons.insert(em, at: 0)
        }else{
            packages.emoticons.remove(at: 19)
            packages.emoticons.insert(em, at: 0)
        }
    }

}
