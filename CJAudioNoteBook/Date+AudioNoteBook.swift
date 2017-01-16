//
//  Date+AudioNoteBook.swift
//  CJAudioNoteBook
//
//  Created by fminor on 16/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import Foundation

// MARK: format output
extension Date {
    public func stringOfEntireTime() -> String {
        return self.string(with: "yyyy-MM-dd HH:mm:ss")
    }
    
    public func stringOfTime() -> String {
        return self.string(with: "HH:mm:ss")
    }
    
    public func stringOfDay() -> String {
        return self.string(with: "yyyy-MM-dd")
    }
    
    public func string(with format: String) -> String {
        let _fmt = DateFormatter()
        _fmt.dateFormat = format
        return _fmt.string(from: self)
    }
}

// MARK: timestamp output
extension Date {
    public func timeStamp() -> String {
        return self.timeIntervalSince1970.description
    }
}
