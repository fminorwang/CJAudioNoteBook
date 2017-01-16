//
//  CJAudioItem.swift
//  CJAudioNoteBook
//
//  Created by fminor on 16/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import Foundation

let tAudioItem = "audioItem"

private let AUDIO_FILE_DIRECOTORY = "/Audio"

public class CJAudioItem: CJBean {
    
    public var fileName: String = ""
    public var date: Date = Date()
    public var duration: Double = 0.0
    
    override init() {
        super.init()
        self.type = tAudioItem
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.fileName = aDecoder.decodeObject(forKey: kModelFileName) as! String
        self.date = aDecoder.decodeObject(forKey: kModelDate) as! Date
        self.duration = aDecoder.decodeDouble(forKey: kModelDuration)
    }
    
    public override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        
        aCoder.encode(self.fileName, forKey: kModelFileName)
        aCoder.encode(self.date, forKey: kModelDate)
        aCoder.encode(self.duration, forKey: kModelDuration)
    }
    
    public override func bean(from jsonDict: [String : Any]) {
        super.bean(from: jsonDict)
        
        self.fileName = jsonDict.value(for: kModelFileName, withDefault: "empty") as! String
        self.date = jsonDict.value(for: kModelDate, withDefault: Date()) as! Date
        self.duration = jsonDict.value(for: kModelDuration, withDefault: 0.0) as! Double
        
        self.type = tAudioItem
        self.beanId = self.date.timeStamp()
        self.name = self.beanId
    }
}

// MARK: properties
extension CJAudioItem {
    public var filePath: String {
        get {
            return CJAudioItem._audioDocumentPath + "/" + self.fileName
        }
    }
}

// MARK: internal
extension CJAudioItem {
    fileprivate static var _audioDocumentPath: String {
        get {
            let _documentPath = NSHomeDirectory() + "/Documents" + AUDIO_FILE_DIRECOTORY
            let _fm = FileManager()
            if ( _fm.fileExists(atPath: _documentPath , isDirectory: nil) == false ) {
                do {
                    try _fm.createDirectory(atPath: _documentPath, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print("Error: " + error.localizedDescription)
                }
            }
            return _documentPath
        }
    }
}
