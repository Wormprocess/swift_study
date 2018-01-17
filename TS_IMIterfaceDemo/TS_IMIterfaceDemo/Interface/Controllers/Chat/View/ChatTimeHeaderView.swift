//
//  ChatTimeHeaderView.swift
//  TS_IMIterfaceDemo
//
//  Created by dome on 2018/1/15.
//  Copyright © 2018年 zwang. All rights reserved.
//

import UIKit
import SnapKit

class ChatTimeHeaderView: UITableViewHeaderFooterView {
    let timeLable : UILabel
    let bgImage: UIImageView
    
    public func render(time: String) {
        timeLable.text = time
    }
    
    override init(reuseIdentifier: String?) {
        timeLable = UILabel()
        bgImage   = UIImageView()
        super.init(reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        timeLable = UILabel()
        bgImage   = UIImageView()
        super.init(coder: aDecoder)
        setUI()
    }
    
    func setUI() {
        contentView.backgroundColor = .clear        
        self.backgroundView = UIView()
        
        bgImage.image = #imageLiteral(resourceName: "time_bubble")
        contentView.addSubview(bgImage)

        timeLable.font = UIFont.systemFont(ofSize: 13)
        timeLable.textColor = UIColor.lightText
        timeLable.textAlignment = NSTextAlignment.center
        contentView.addSubview(timeLable)
        
        timeLable.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(CGFloat(24))
            make.width.greaterThanOrEqualTo(CGFloat(100))
        }
        
        bgImage.snp.makeConstraints { (make) in
            make.top.equalTo(timeLable.snp.top).offset(-2)
            make.bottom.equalTo(timeLable.snp.bottom).offset(2)
            make.left.equalTo(timeLable.snp.left).offset(-10)
            make.right.equalTo(timeLable.snp.right).offset(10)
        }
        
    }
}

