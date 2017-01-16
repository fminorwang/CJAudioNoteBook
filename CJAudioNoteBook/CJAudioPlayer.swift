//
//  CJAudioPlayer.swift
//  CJAudioNoteBook
//
//  Created by fminor on 16/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import Foundation

protocol CJAudioPlayer {
    
    func startToPlay(with filePath: String) -> Void
    
    func pause() -> Void
    
    func resume() -> Void
    
    func stop() -> Void
    
    var isPlaying: Bool { get }
}
