//
//  ChatTextCell.swift
//  TS_IMIterfaceDemo
//
//  Created by dome on 2018/1/15.
//  Copyright © 2018年 zwang. All rights reserved.
//

import UIKit
import SnapKit
import YYText

class ChatTextCell: ChatCell {
    var contentLabel: UILabel!
    
    var spacingConstraint: Constraint?
    var contentWidthConstraint: Constraint?
    var contentHeightConstraint: Constraint?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createContentLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createContentLabel()
    }
    
    func createContentLabel() {
        contentLabel = UILabel()
        contentLabel.font = UIFont .systemFont(ofSize: 17)
        contentLabel.textColor = UIColor.red
        contentLabel.numberOfLines = 0
        containerView.addSubview(contentLabel)
        
        if self.reuseIdentifier == "cell_identifier_text" {
            contentLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(bubbleImageView.snp.left).offset(20)
                make.top.equalTo(bubbleImageView.snp.top).offset(8)
                make.bottom.equalTo(bubbleImageView.snp.bottom).offset(-9)
                make.right.equalTo(bubbleImageView.snp.right).offset(-13)
//                contentWidthConstraint = make.width.equalTo(CGFloat(146)).priority(750).constraint
//                contentHeightConstraint = make.height.equalTo(CGFloat(110)).priority(750).constraint
            })
        }
    }
    
    override func render(item: MessageItem) {
        model = item
        contentLabel.text = "//model?.content//model?.content//model?.content"
    }
    
}

extension ChatTextCell: MessageLabelDelegate {
    func labelDidSelectedLinkText(label: MessageLabel, text: String, type: LinkType) {
        switch type {
        case .phone:
            print(text)
        case .email:
            print(text)
        default:
            UIApplication.shared.openURL(string: text)
        }
    }
    
//    func prepareContentLabel()  {
//        contentLabel.delegate = self
//    }
    
    
}
