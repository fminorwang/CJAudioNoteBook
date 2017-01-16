//
//  CJSimplePlayer.swift
//  CJAudioNoteBook
//
//  Created by fminor on 16/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import Foundation
import AVFoundation

/**
 CJSimplePlayer 只能用于播放本地音频文件
 */
class CJSimplePlayer: CJAudioPlayer {
    
    fileprivate var _iPlayer: AVAudioPlayer?
    public var playingPath: String?
    
    init() {
        
    }
}

// MARK: audio player protocol
extension CJSimplePlayer {
    func startToPlay(with filePath: String) {
        _clear()
        _init(with: filePath)
        _iPlayer?.play()
    }
    
    func stop() {
        _iPlayer?.stop()
        _clear()
    }
    
    func pause() {
        _iPlayer?.pause()
    }
    
    func resume() {
        _iPlayer?.play()
    }
    
    public var isPlaying: Bool {
        get {
            if let _isPlaying = _iPlayer?.isPlaying {
                return _isPlaying
            }
            return false
        }
    }
}

// MARK: internal
extension CJSimplePlayer {
    
    fileprivate func _init(with filePath: String?) {
        if let _filePath = filePath {
            self.playingPath = _filePath
            let _url = URL(fileURLWithPath: _filePath)
            do {
                try _iPlayer = AVAudioPlayer(contentsOf: _url)
            } catch {
                print("AVAudioPlayer initialize failed! " + error.localizedDescription)
            }
        }
    }
    
    fileprivate func _clear() {
        _iPlayer = nil
        self.playingPath = nil
    }
}
