//
//  CJDataCache.swift
//  CJAudioNoteBook
//
//  Created by fminor on 14/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import Foundation
import CoreData

enum CJDataCacheError: Error {
    case cannotFindDataModel
    case migrateStoreFailed
    case notFoundPSC
}

private let kInnerBeanEntity = "CJInnerBean"
private let kDataCacheData = "data"
private let kDataCacheKey = "key"

/**
 基于 CoreData 简单实现 key-value 存储
 
 获取数据: data(for: "anykey")
 新增、修改数据: set(data: anyData for: "anykey")
 删除数据: set(data: nil for: "anykey")
 
 写入数据 data 必须为实现 NSCoding 协议的 Class。
 */
open class CJDataCache {
    
    fileprivate var _context: NSManagedObjectContext?
    
    init(name: String) {
        do {
            try _initializeDataCache(with: name)
        } catch {
            fatalError("Initialize data cache failed!")
        }
    }
    
    open func data(for key:String) -> Any? {
        guard let _mo = _getManagedObject(for: key) else {
            return nil
        }
        let _data: Data = _mo.value(forKey: kDataCacheData) as! Data
        let _unarchiver = NSKeyedUnarchiver(forReadingWith: _data)
        return _unarchiver.decodeObject()
    }
    
    open func set(data:NSCoding?, for key:String) {
        guard let _data = data else {
            // 删除数据
            _delete(for: key)
            return
        }
        
        // 修改数据
        if let _mo = _getManagedObject(for: key) {
            _modify(data: _data, for: key, into: _mo)
            return
        }
        
        // 插入数据
        _insert(data: _data, for: key)
        return
    }
}

// MARK: 初始化
extension CJDataCache {
    fileprivate func _initializeDataCache(with name: String) throws {
        let _bundle = Bundle.main
        guard let _modelURL = _bundle.url(forResource: "CJDataModel", withExtension: "momd") else {
            throw CJDataCacheError.cannotFindDataModel
        }
        
        guard let _model = NSManagedObjectModel(contentsOf: _modelURL) else {
            throw CJDataCacheError.cannotFindDataModel
        }
        
        let _moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        _moc.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: _model)
        _context = _moc
        
        let _fileManager = FileManager.default
        let _documentsURL = _fileManager.urls(for: .documentDirectory, in: .userDomainMask).last
        let _storeURL = _documentsURL?.appendingPathComponent(name + ".sql")
        
        guard let _psc = self._context?.persistentStoreCoordinator else {
            throw CJDataCacheError.notFoundPSC
        }
        
        do {
            try _psc.addPersistentStore(ofType: NSSQLiteStoreType,
                                        configurationName: nil,
                                        at: _storeURL,
                                        options: nil)
            print("Init data manager success.")
        } catch {
            throw CJDataCacheError.migrateStoreFailed
        }

    }
}

// MARK: 数据库操作
extension CJDataCache {
    
    fileprivate func _delete(for key: String) {
        guard let _mo = _getManagedObject(for: key) else {
            return
        }
        _context?.delete(_mo)
        _save()
    }
    
    fileprivate func _modify(data: NSCoding, for key: String, into mo: NSManagedObject) {
        let _dataToBeSaved = NSMutableData()
        let _archiver = NSKeyedArchiver(forWritingWith: _dataToBeSaved)
        _archiver.encodeRootObject(data)
        _archiver.finishEncoding()
        mo.setValue(_dataToBeSaved, forKey: kDataCacheData)
        _save()
    }
    
    fileprivate func _insert(data: NSCoding, for key: String) {
        guard let _context = _context else {
            return;
        }
        let _bean = NSEntityDescription.insertNewObject(forEntityName: kInnerBeanEntity, into: _context)
        let _dataToBeSaved = NSMutableData()
        let _archiver = NSKeyedArchiver(forWritingWith: _dataToBeSaved)
        _archiver.encodeRootObject(data)
        _archiver.finishEncoding()
        _bean.setValue(_dataToBeSaved, forKey: kDataCacheData)
        _bean.setValue(key, forKey: kDataCacheKey)
        _save()
        return
    }
    
    fileprivate func _save() {
        do {
            try _context?.save()
        } catch {
            print("Save data failed! Error: " + error.localizedDescription)
        }
    }
    
    fileprivate func _getManagedObject(for key:String) -> NSManagedObject? {
        let _request = NSFetchRequest<NSFetchRequestResult>(entityName: kInnerBeanEntity)
        _request.predicate = NSPredicate(format: "key == %@", key)
        do {
            guard let _beans = try _context?.fetch(_request) else {
                return nil
            }
            if _beans.count == 0 {
                return nil
            }
            return _beans[0] as? NSManagedObject
        } catch {
            print("Fetch object failed! Error: %@", error.localizedDescription)
            return nil
        }
    }
}
