//
//  MessageTextView.swift
//  TS_IMIterfaceDemo
//
//  Created by dome on 2018/1/16.
//  Copyright © 2018年 zwang. All rights reserved.
//

import UIKit
class MessageTextView: UITextView {
    public weak var overrideNext: UIResponder?
    
    override var next: UIResponder? {
        if let responder = overrideNext {
            return responder
        }
        return super.next
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        guard overrideNext == nil else {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
