//
//  CJAudioAgent.swift
//  CJAudioNoteBook
//
//  Created by fminor on 16/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import Foundation
import AVFoundation

public class CJAudioAgent {
    
    // singleton
    public static let shared = CJAudioAgent()
    
    // recorder
    fileprivate var _iRecorder: CJAudioRecorder = CJSimpleRecorder()
    
    init() {
        
    }
}

// MARK: recorder
extension CJAudioAgent {
    public func startToRecord() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord)
        } catch {
            print("Error: " + error.localizedDescription)
        }
        _iRecorder.start(with: "test")
    }
    
    public func stopToRecord() {
        _iRecorder.stop()
    }
}

// MARK: player
extension CJAudioAgent {
    public func startToPlay(item: NSURL) {
        
    }
}
