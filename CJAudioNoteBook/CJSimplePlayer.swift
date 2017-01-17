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
class CJSimplePlayer: NSObject, CJAudioPlayer, AVAudioPlayerDelegate {
    
    fileprivate var _iPlayer: AVAudioPlayer?
    
    public var playingPath: String?
    public var delegate: CJAudioPlayerDelegate?
}

// MARK: audio player protocol
extension CJSimplePlayer {
    func startToPlay(with filePath: String) {
        _clear()
        _init(with: filePath)
        if let _play = _iPlayer?.play(), _play == true {
            self.delegate?.CJAudioPlayer(self, startToPlay: filePath)
        }
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
    
    public var duration: Double {
        get {
            if let _duration = _iPlayer?.duration {
                return _duration
            }
            return 0.0
        }
    }
    
    public var currentProgress: Double {
        get {
            if let _progress = _iPlayer?.currentTime {
                return _progress
            }
            return 0.0
        }
    }
}

// MARK: AVAudioPlayer delegate
extension CJSimplePlayer {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let _playingPath = self.playingPath {
            self.delegate?.CJAudioPlayer(self, finishToPlay: _playingPath)
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
                _iPlayer?.delegate = self
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
