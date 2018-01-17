//
//  ChatCell.swift
//  TS_IMIterfaceDemo
//
//  Created by dome on 2018/1/15.
//  Copyright © 2018年 zwang. All rights reserved.
//

import UIKit
import SnapKit

protocol ChatCellDelegate: class {
    func longPressMenu(cell: ChatCell, item: MessageItem, rect: CGRect)
}

class ChatCell: UITableViewCell {
    
    var containerView: UIView!
    var bubbleImageView: UIImageView!
    var timeLable: UILabel!
    
    internal var model: MessageItem?
    
    var currentUserid = AccountAPI.shared.account?.id ?? ""
    
    weak var delegate: ChatCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        buildView()
    }
    
    func render(item: MessageItem)  {
        
    }
    
    func buildView() {
        backgroundColor = .clear
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
        
        let long = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(_:)))
        long.minimumPressDuration = 0.8
        addGestureRecognizer(long)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willHideMenu(_:)), name: Notification.Name.UIMenuControllerWillHideMenu, object: nil)
        
        containerView = UIView()
        contentView.addSubview(containerView)
        
        bubbleImageView = UIImageView()
        containerView.addSubview(bubbleImageView)
        
        timeLable = UILabel()
        timeLable.textColor = UIColor.lightText
        timeLable.font = UIFont.systemFont(ofSize: 11)
        timeLable.textAlignment = NSTextAlignment.right
        containerView.addSubview(timeLable)
        
        if let identifier = self.reuseIdentifier {
            if identifier == "cell_identifier_text" || identifier == "photo_identifier_text"{
                bubbleImageView.image = #imageLiteral(resourceName: "ic_chat_bubble_left")
                bubbleImageView.highlightedImage = #imageLiteral(resourceName: "ic_chat_bubble_left_tail")
                containerView.snp.makeConstraints({ (make) in
                    make.left.equalTo(contentView.snp.left).offset(8)
                    make.top.equalTo(contentView.snp.top).offset(10)
                    make.bottom.equalTo(contentView.snp.bottom)
                    make.right.lessThanOrEqualTo(contentView.snp.right).offset(-15)
                })
                bubbleImageView.snp.makeConstraints({ (make) in
                    make.edges.equalToSuperview()
                })
                timeLable.snp.makeConstraints({ (make) in
                    make.bottom.equalToSuperview()
                    make.right.equalToSuperview()
                    make.size.equalTo(CGSize(width: 76, height: 14))
                })
            }else{
                bubbleImageView.image = #imageLiteral(resourceName: "ic_chat_bubble_right")
                bubbleImageView.highlightedImage = #imageLiteral(resourceName: "ic_chat_bubble_right_tail")
                containerView.snp.makeConstraints({ (make) in
                    make.right.equalTo(contentView.snp.left).offset(8)
                    make.top.equalTo(contentView.snp.top).offset(10)
                    make.bottom.equalTo(contentView.snp.bottom)
                    make.left.lessThanOrEqualTo(contentView.snp.left).offset(15)
                })
                bubbleImageView.snp.makeConstraints({ (make) in
                    make.edges.equalToSuperview()
                })
                timeLable.snp.makeConstraints({ (make) in
                    make.bottom.equalToSuperview()
                    make.right.equalToSuperview()
                    make.size.equalTo(CGSize(width: 76, height: 14))
                })
            }
        }
        
    }
    
    @objc func longPressAction(_ sender: UIGestureRecognizer) {
        
    }
    @objc
    func willHideMenu(_ sender: NSNotification)  {
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}
