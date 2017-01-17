//
//  CJSimpleRecorder.swift
//  CJAudioNoteBook
//
//  Created by fminor on 15/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import Foundation
import AVFoundation

public class CJSimpleRecorder: CJMeasurableAudioPlayer {
    
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
    
    func stop() -> Double {
        print("Stop recording.")
        var _duration = 0.0
        if let _currentDuration = _iRecorder?.currentTime {
            _duration = _currentDuration
        }
        _iRecorder?.stop()
        return _duration
    }
    
    func pause() {
        print("Pause recording.")
        _iRecorder?.pause()
    }
    
    public var isRecording: Bool {
        get {
            if let _isRecording = _iRecorder?.isRecording {
                return _isRecording
            }
            return false
        }
    }
}

// MARK: measure
extension CJSimpleRecorder {
    var currentVolume: Float {
        get {
            if self.isRecording == false {
                return 0.0
            }
            _iRecorder!.updateMeters()
            return _iRecorder!.averagePower(forChannel: 0)
        }
    }
}

// MARK: internal methods
extension CJSimpleRecorder {
    fileprivate func _init(with filePath: String?) {
        _clear()
        
        guard let _filePath = filePath else {
            print("Error: empty file name!")
            return
        }
        
        let _url = URL(fileURLWithPath: _filePath)
        do {
            try _iRecorder = AVAudioRecorder(url: _url, settings: [:])
            _iRecorder?.isMeteringEnabled = true
        } catch {
            print("Initalize audio recorder failed! " + error.localizedDescription)
            return
        }
    }
    
    fileprivate func _clear() {
        _iRecorder = nil
        _fileName = nil
    }
}
