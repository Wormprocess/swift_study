//
//  LocalizedExtension.swift
//  TS_IMIterfaceDemo
//
//  Created by dome on 2018/1/13.
//  Copyright © 2018年 zwang. All rights reserved.
//

import UIKit

public func LocalizedString(_ key: String, comment: String) -> String {
    let localText = NSLocalizedString(key, comment: comment)
    return localText == key ? comment : localText
}

extension UIButton {
    @IBInspectable
    var  local_title: String? {
        get{
            return ""
        }
        set{
            guard let text = newValue, !text.isEmpty else {
                return
            }
            let localText = LocalizedString(text, comment: text)
            if localText != text {
                self.setTitle(localText, for: UIControlState.normal)
            }
        }
    }
    
}

extension UILabel {
    
    @IBInspectable
    var local_title: String? {
        get {
            return ""
        }
        set {
            guard let text = newValue, !text.isEmpty else {
                return
            }
            let localText = LocalizedString(text, comment: text)
            if localText != text {
                self.text = localText
            }
        }
    }
}

extension UITextField {
    
    @IBInspectable
    var local_placeholder: String? {
        get {
            return ""
        }
        set {
            guard let text = newValue, !text.isEmpty else {
                return
            }
            let localText = LocalizedString(text, comment: text)
            if localText != text {
                self.placeholder = localText
            }
        }
    }
    
}

extension UINavigationItem {
    
    @IBInspectable
    var local_title: String? {
        get {
            return ""
        }
        set {
            guard let text = newValue, !text.isEmpty else {
                return
            }
            let localText = LocalizedString(text, comment: text)
            if localText != text {
                self.title = localText
            }
        }
    }
    
}
