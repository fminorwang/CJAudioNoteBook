//
//  CJAudioRecorder.swift
//  CJAudioNoteBook
//
//  Created by fminor on 15/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import Foundation

protocol CJAudioRecorder {
    
    func start(with filePath: String) -> Void
    
    func stop() -> Double   // 结束录音，返回录音时长
    
    func pause() -> Void
    
    var isRecording: Bool { get }
}

protocol CJMeasurableAudioPlayer: CJAudioRecorder {
    
    var currentVolume: Float { get }
}
