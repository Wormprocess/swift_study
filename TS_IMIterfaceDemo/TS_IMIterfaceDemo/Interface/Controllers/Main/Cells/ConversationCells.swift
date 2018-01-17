//
//  ConversationCells.swift
//  TS_IMIterfaceDemo
//
//  Created by dome on 2018/1/5.
//  Copyright © 2018年 zwang. All rights reserved.
//

import UIKit
import SnapKit

class ConversationCells: UITableViewCell {

    var headImage: AvatarImageView!
    
    var nickNameLabel: UILabel!
    
    var contentLabel:UILabel!
    
    var timeLable :UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        headImage = AvatarImageView(frame: CGRect.zero)
        headImage.cornerRadius = 24
        contentView.addSubview(headImage)
        
        nickNameLabel = UILabel()
        nickNameLabel.font = UIFont.systemFont(ofSize: 17)
        contentView.addSubview(nickNameLabel)
        
        contentLabel = UILabel()
        contentLabel.textColor = UIColor.lightGray
        contentView.addSubview(contentLabel)
        
        timeLable = UILabel()
        timeLable.textColor = UIColor.lightGray
        timeLable.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(timeLable)
        
        createLayout()
    }
    
    func createLayout() {
        headImage.snp.makeConstraints{ make in
            make.left.equalTo(contentView).offset(15)
            make.size.equalTo(CGSize(width: 48, height: 48))
            make.centerY.equalToSuperview()
        }
        
        nickNameLabel.snp.makeConstraints{ make in
            make.left.equalTo(headImage.snp.right).offset(10)
            make.top.equalTo(headImage)
            
        }
        
        contentLabel.snp.makeConstraints{ make in
            make.left.equalTo(nickNameLabel)
            make.top.equalTo(nickNameLabel).offset(8)
            make.right.greaterThanOrEqualTo(contentView).offset(-16)
        }
        
        timeLable.snp.makeConstraints{ make in
            make.top.equalTo(headImage)
            make.right.equalTo(contentView).offset(-15)
        }
    }
    
    func sender(item: ConversationItem) {
        headImage.setImage(with: item.iconUrl, identityNumber: item.userIdentityNumber, name: item.name)
        nickNameLabel.text = item.name
        contentLabel.text = item.content
        timeLable.text = item.created_at.timeAgo()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
