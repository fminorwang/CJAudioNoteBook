//
//  CJAudioRecorder.swift
//  CJAudioNoteBook
//
//  Created by fminor on 15/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import Foundation

protocol CJAudioRecorder {
    
    func start(with fileName: String) -> Void
    
    func stop() -> Void
    
    func pause() -> Void
}
