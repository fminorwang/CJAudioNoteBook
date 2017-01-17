//
//  CJAudioPlayer.swift
//  CJAudioNoteBook
//
//  Created by fminor on 16/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import Foundation

public protocol CJAudioPlayer {
    
    func startToPlay(with filePath: String) -> Void
    
    func pause() -> Void
    
    func resume() -> Void
    
    func stop() -> Void
    
    var isPlaying: Bool { get }
    
    /// 音频文件时长
    var duration: Double { get }
    
    /// 当前播放时间
    var currentProgress: Double { get }
    
    var delegate: CJAudioPlayerDelegate? { get set }
}

public protocol CJAudioPlayerDelegate {
    
    func CJAudioPlayer(_ player: CJAudioPlayer, startToPlay filePath: String)
    
    func CJAudioPlayer(_ player: CJAudioPlayer, finishToPlay filePath: String)
}

extension CJAudioPlayerDelegate {
    
    func CJAudioPlayer(_ player: CJAudioPlayer, startToPlay filePath: String) {
        
    }
    
    func CJAudioPlayer(_ player: CJAudioPlayer, finishToPlay filePath: String) {
        
    }
}
