//
//  Message.swift
//  TS_IMIterfaceDemo
//
//  Created by dome on 2018/1/13.
//  Copyright © 2018年 zwang. All rights reserved.
//

import Foundation

struct Message: Codable {
    let id: String
    let conversation_id: String
    let user_id: String
    let type: MessageType
    let content: String
    let card_title: String
    let card_remark: String
    let created_at: Date
    let status: String

}

enum MessageStatus: String, Codable {
    case sending
    case delivered
    case unread
    case read
    case failed
}

enum MessageType: String, Codable {
    case text
    case photo
    case audio
    case video
    case sticker
}
