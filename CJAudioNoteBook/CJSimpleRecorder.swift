//
//  CJSimpleRecorder.swift
//  CJAudioNoteBook
//
//  Created by fminor on 15/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import Foundation
import AVFoundation

private let AUDIO_FILE_DIRECOTORY = "/Audio"

public class CJSimpleRecorder: CJAudioRecorder {
    
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
    
    fileprivate var _fileName: String?
    fileprivate var _iRecorder: AVAudioRecorder?
    
    init(fileName: String? = nil) {
        _fileName = fileName
    }
}

// MARK: Audio Recorder Protocol
extension CJSimpleRecorder {
    func start(with fileName: String) {
        _init(with: fileName)
        print("Start recording.")
        if _iRecorder?.record() == false {
            print("Error: start recording failed!")
        }
    }
    
    func stop() {
        print("Stop recording.")
        _iRecorder?.stop()
    }
    
    func pause() {
        print("Pause recording.")
        _iRecorder?.pause()
    }
}

// MARK: internal methods
extension CJSimpleRecorder {
    fileprivate func _init(with fileName: String?) {
        _clear()
        
        guard let _fileName = fileName else {
            print("Error: empty file name!")
            return
        }
        
        let _url = URL(fileURLWithPath: CJSimpleRecorder._audioDocumentPath + "/" + _fileName)
        do {
            try _iRecorder = AVAudioRecorder(url: _url, settings: [:])
        } catch {
            print("Error: " + error.localizedDescription)
            return
        }
    }
    
    fileprivate func _clear() {
        _iRecorder = nil
        _fileName = nil
    }
}
