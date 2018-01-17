//
//  FMResultSetExtension.swift
//  TS_IMIterfaceDemo
//
//  Created by dome on 2018/1/15.
//  Copyright © 2018年 zwang. All rights reserved.
//

import FMDB

extension FMResultSet {
    func getString(forColumn: String) -> String {
        return string(forColumn: forColumn) ?? ""
    }
    
    func getInt(forColumn: String) -> Int {
        return Int(int(forColumn: forColumn))
    }
    
    func getDate(forColumn: String) -> Date {
        return date(forColumn: forColumn) ?? Date()
    }
}
