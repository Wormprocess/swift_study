//
//  MessageLabel.swift
//  TS_IMIterfaceDemo
//
//  Created by dome on 2018/1/16.
//  Copyright © 2018年 zwang. All rights reserved.
//

import UIKit
import YYText

protocol MessageLabelDelegate: class {
    func labelDidSelectedLinkText(label: MessageLabel, text: String, type: LinkType)
}

enum LinkType {
    case email
    case phone
    case url
}

let regexEmail = try? NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}", options: NSRegularExpression.Options(rawValue: 0))

let regexPhone = try? NSRegularExpression(pattern: "^[1-9][0-9]{4,11}$", options: NSRegularExpression.Options(rawValue: 0))

let regexUrl = try? NSRegularExpression(pattern: "((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)", options: NSRegularExpression.Options(rawValue: 0))

class MessageLabel: YYLabel {
    weak var  delegate: MessageLabelDelegate?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        prepaerLabel()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepaerLabel()
    }
    
    private func prepaerLabel() {
        numberOfLines = 0
        displaysAsynchronously = true
        backgroundColor = .clear
        isUserInteractionEnabled = true
        
        highlightTapAction = { [weak self] (containerView, text, range, rect) in
            guard let weakSelf = self else {
                return
            }
            
            let highLight: YYTextHighlight = text.yy_attribute(YYTextHighlightAttributeName, at: UInt(range.location)) as! YYTextHighlight
            
            if let info = highLight.userInfo {
                let linkValue: String = info["linkValue"] as! String
                let linkType = info["linkType"] as! LinkType
                weakSelf.delegate?.labelDidSelectedLinkText(label: weakSelf, text: linkValue, type: linkType)
            }
        }
    }
    
    public func textSize(text: NSAttributedString, size: CGSize) -> CGSize {
        let container = YYTextContainer(size: size)
        let layout = YYTextLayout(container: container, text: text)
        return layout!.textBoundingSize
    }
    
    public func textHandle(text: NSMutableAttributedString){
        let highlightBorder = YYTextBorder()
        highlightBorder.insets = UIEdgeInsetsMake(0, 0, 0, 0)
        highlightBorder.cornerRadius = 5.0
        highlightBorder.fillColor = UIColor(white: 0.8, alpha: 0.5)
        
        if let resultEmail = regexEmail?.matches(in: text.string, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: text.yy_rangeOfAll()) {
            for at: NSTextCheckingResult in resultEmail{
                if at.range.location == NSNotFound && at.range.length <= 1{
                    continue
                }
                if text.yy_attribute(YYTextHighlightAttributeName, at: UInt(at.range.location)) == nil{
                    let highlight = YYTextHighlight()
                    highlight.setBackgroundBorder(highlightBorder)
                    highlight.userInfo = ["linkValue" : NSString.init(string: text.string).substring(with: at.range),
                                          "linkType" : LinkType.email]
                    text.yy_setTextHighlight(highlight, range: at.range)
                    text.yy_setColor(UIColor.blue, range: at.range)
                }
            }
        }
        
        // phone
        if let resultPhone = regexPhone?.matches(in: text.string, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: text.yy_rangeOfAll()) {
            
            for at: NSTextCheckingResult in resultPhone {
                
                if at.range.location == NSNotFound && at.range.length <= 1 {
                    continue
                }
                
                if text.yy_attribute(YYTextHighlightAttributeName, at: UInt(at.range.location)) == nil {
                    
                    let highlight = YYTextHighlight()
                    highlight.setBackgroundBorder(highlightBorder)
                    highlight.userInfo = [
                        "linkValue" : NSString.init(string: text.string).substring(with: at.range),
                        "linkType" : LinkType.phone
                    ]
                    text.yy_setTextHighlight(highlight, range: at.range)
                    text.yy_setColor(UIColor.blue, range: at.range)
                }
            }
        }
        
        // url
        if let resultUrl = regexUrl?.matches(in: text.string, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: text.yy_rangeOfAll()) {
            
            for at: NSTextCheckingResult in resultUrl {
                
                if at.range.location == NSNotFound && at.range.length <= 1 {
                    continue
                }
                
                if text.yy_attribute(YYTextHighlightAttributeName, at: UInt(at.range.location)) == nil {
                    
                    let highlight = YYTextHighlight()
                    highlight.setBackgroundBorder(highlightBorder)
                    highlight.userInfo = [
                        "linkValue" : NSString.init(string: text.string).substring(with: at.range),
                        "linkType" : LinkType.url
                    ]
                    text.yy_setTextHighlight(highlight, range: at.range)
                    text.yy_setColor(UIColor.blue, range: at.range)
                }
            }
        }
    }
    
    
}
