//
//  NotificationCenterExtension.swift
//  TS_IMIterfaceDemo
//
//  Created by dome on 2018/1/15.
//  Copyright © 2018年 zwang. All rights reserved.
//

import UIKit

extension NotificationCenter {
    func postOnMain(name: Notification.Name, object: Any? = nil) {
        if Thread.isMainThread {
            post(name: name, object: object)
        }else {
            DispatchQueue.main.async {
                self.post(name: name, object: object)
            }
        }
    }
}
