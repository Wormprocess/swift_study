//
//  UserDAO.swift
//  TS_IMIterfaceDemo
//
//  Created by dome on 2018/1/9.
//  Copyright © 2018年 zwang. All rights reserved.
//

import FMDB

final class UserDAO: BaseDAO{
    static let tableName = "users"
    static let shared = UserDAO()
    
    private static let idColumn = "id"
    private static let fullNameColumn  = "full_name"
    private static let identityNumberColumn = "identity_number"
    private static let typeColumn = "type"
    private static let avatarUrlColumn = "avatar_url"
    
    private static let phoneColumn = "phone"
    private static let countryColumn = "country"
    
    private  static let reputationColumn = "reputation"
    private static let aliasNameColumn = "alisa_name"
    private static let isVerifiedColumn = "is_verified"
    private static let isBlockedColumn = "is_blocked"
    private static let isNotificationEnabledColumn = "is_notification_enabled"
    private static let createdAtColumn = "created_at"
    
    
    static let sqlCreateTable = """
    CREATE TABLE IF NOT EXISTS \(tableName) (
    \(idColumn) TEXT PRIMARY KEY,
    \(fullNameColumn) TEXT,
    \(typeColumn) TEXT,
    \(aliasNameColumn) TEXT,
    \(identityNumberColumn) TEXT,
    \(avatarUrlColumn) TEXT,
    \(phoneColumn) TEXT,
    \(countryColumn) TEXT,
    \(reputationColumn) INTEGER DEFAULT 0,
    \(isVerifiedColumn) INTEGER DEFAULT 0,
    \(isBlockedColumn) INTEGER DEFAULT 0,
    \(isNotificationEnabledColumn) INTEGER DEFAULT 0,
    \(createdAtColumn) INTEGER);
    """
    
    static let sqlAddUniqueIndex = "CREATE UNIQUE INDEX user_index_id ON \(tableName)(\(idColumn));"
    
    static let sqlInsert = """
    INSERT INTO \(tableName) (
    \(idColumn),
    \(fullNameColumn),
    \(typeColumn),
    \(aliasNameColumn),
    \(identityNumberColumn),
    \(avatarUrlColumn),
    \(phoneColumn),
    \(countryColumn),
    \(reputationColumn),
    \(isVerifiedColumn),
    \(isBlockedColumn),
    \(isNotificationEnabledColumn),
    \(createdAtColumn)
    ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?);
    """
    
    
}

