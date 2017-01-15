//
//  CJDataManager.swift
//  CJAudioNoteBook
//
//  Created by fminor on 14/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import Foundation

private let kDataCacheFileName = "dataCacheV1"

class CJDataManager {
    
    // singleton
    static public let shared = CJDataManager()
    
    private let _dataCache = CJDataCache(name: kDataCacheFileName)
    private init() {
        
    }
    
    func data(for key: String) -> Any? {
        return _dataCache.data(for: key)
    }
    
    func set(data: NSCoding?, for key: String) {
        _dataCache.set(data: data, for: key)
    }
}
