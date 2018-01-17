//
//  AvatarImageView.swift
//  TS_IMIterfaceDemo
//
//  Created by dome on 2018/1/9.
//  Copyright © 2018年 zwang. All rights reserved.
//

import UIKit
import SnapKit
import PINRemoteImage

class AvatarImageView: CornerImageView {
    var titleLabel: UILabel!
    
    @IBInspectable
    var titleFontSize: CGFloat = 17 {
        didSet{
            titleLabel.font = UIFont.systemFont(ofSize: titleFontSize)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    private func prepare() {
        
        titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: titleFontSize)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints{
            make in
            make.center.equalToSuperview()
        }
    }
    
    func setImage(with url: String,identityNumber: String,name: String)  {
        if let url = URL(string: url) {
            pin_setImage(from: url, placeholderImage: #imageLiteral(resourceName: "ic_place_holder"))
        }else{
        
            if let firstLetter = name.first{
                titleLabel.text = String([firstLetter]).uppercased()
            }else{
                titleLabel.text = nil
            }
            
            if let number = Int(identityNumber){
                image = UIImage(named: "color\(number % 24 + 1)")
                backgroundColor = UIColor.clear
            }else{
                image = nil
                backgroundColor = UIColor(rgbValue: 0xaaaaaa)
            }
        }
        
    }
}
