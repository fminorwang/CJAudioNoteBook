//
//  Dictionary+AudioNoteBook.swift
//  CJAudioNoteBook
//
//  Created by fminor on 16/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import Foundation

extension Dictionary {
    func value(for aKey: Key, withDefault aValue: Any) -> Any {
        if let _value = self[aKey] {
            return _value
        } else {
            return aValue
        }
    }
}
