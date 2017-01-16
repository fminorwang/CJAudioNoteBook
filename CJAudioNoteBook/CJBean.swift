//
//  CJBean.swift
//  CJAudioNoteBook
//
//  Created by fminor on 16/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import Foundation

let tBean = "tBean"

let kModelName = "name"
let kModelBeanId = "beanId"
let kModelType = "type"

let kModelDate = "date"
let kModelFileName = "file_name"
let kModelDuration = "duration"

public class CJBean: NSObject, NSCoding {
    
    public var type: String = tBean
    public var name: String = ""
    public var beanId: String = ""
    
    override init() {
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: kModelName) as! String
        self.beanId = aDecoder.decodeObject(forKey: kModelBeanId) as! String
        self.type = aDecoder.decodeObject(forKey: kModelType) as! String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.type, forKey: kModelType)
        aCoder.encode(self.name, forKey: kModelName)
        aCoder.encode(self.beanId, forKey: kModelBeanId)
    }
    
    // beanIdentify 作为各种数据类型的 key 存储在数据库中
    public var beanIdentity: String {
        get {
            return "\(type)/\(beanId)"
        }
    }
    
    public func bean(from jsonDict:[String: Any]) {
        self.name = jsonDict.value(for: kModelName, withDefault: "") as! String
        self.beanId = jsonDict.value(for: kModelName, withDefault: "") as! String
        self.type = jsonDict.value(for: kModelType, withDefault: tBean) as! String
    }
}
