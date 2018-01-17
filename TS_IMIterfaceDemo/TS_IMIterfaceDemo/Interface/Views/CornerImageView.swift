//
//  CornerImageView.swift
//  TS_IMIterfaceDemo
//
//  Created by dome on 2018/1/9.
//  Copyright © 2018年 zwang. All rights reserved.
//

import UIKit

class CornerImageView: UIImageView {

    @IBInspectable var cornerRadius: CGFloat{
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

}
