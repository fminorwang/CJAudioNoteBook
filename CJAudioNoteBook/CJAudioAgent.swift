//
//  CJAudioAgent.swift
//  CJAudioNoteBook
//
//  Created by fminor on 16/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import Foundation
import AVFoundation

private let kAllRecords = "kAllRecords"

public protocol CJAudioAgentDelegate: class {
    
    func audioAgent(_ agent: CJAudioAgent, startToRecord item: CJAudioItem)
    
    func audioAgent(_ agent: CJAudioAgent, finishRecording item: CJAudioItem)
    
    func audioAgent(_ agent: CJAudioAgent, startToPlay item: CJAudioItem)
    
    func audioAgent(_ agent: CJAudioAgent, finishPlaying item: CJAudioItem)
    
    func audioAgent(_ agent: CJAudioAgent, update progress: Double, total Duration: Double)
}

extension CJAudioAgentDelegate {
    
    func audioAgent(_ agent: CJAudioAgent, startToRecord item: CJAudioItem) { }
    
    func audioAgent(_ agent: CJAudioAgent, finishRecording item: CJAudioItem) { }
    
    func audioAgent(_ agent: CJAudioAgent, startToPlay item: CJAudioItem) { }
    
    func audioAgent(_ agent: CJAudioAgent, finishPlaying item: CJAudioItem) { }
    
    func audioAgent(_ agent: CJAudioAgent, update progress: Double, total duration: Double) { }
}

public class CJAudioAgent: CJAudioPlayerDelegate {
    
    public static let shared = CJAudioAgent()           // singleton
    
    fileprivate var _iRecorder: CJMeasurableAudioPlayer = CJSimpleRecorder()        // recorder
    fileprivate var _recordTimer: Timer? = nil
    
    fileprivate var _iPlayer: CJAudioPlayer = CJSimplePlayer()      // player
    fileprivate var _playTimer: Timer? = nil
    
    fileprivate var _recordVolumeLayerArr = [CJBaseRecordVolumeLayer]()
    fileprivate var _delegates = [CJAudioAgentDelegate]()
    
    public var currentRecordingItem: CJAudioItem?
    public var currentPlayingItem: CJAudioItem?
    
    // playing properties
    public var playingDuration: Double {
        get {
            return _iPlayer.duration
        }
    }
    
    public var playingProgress: Double {
        get {
            return _iPlayer.currentProgress
        }
    }
    
    public func isPlaying(audioItem: CJAudioItem) -> Bool {
        if let _currentItem = self.currentPlayingItem,
            _currentItem.beanIdentity == audioItem.beanIdentity,
            _iPlayer.isPlaying {
            return true
        }
        return false
    }
    
    init() {
        _iPlayer.delegate = self
    }
}

// MARK: recorder
extension CJAudioAgent {
    
    public func startToRecord() {
        self.stopPlaying()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord)
            try AVAudioSession.sharedInstance().setActive(true)
            
            let _date = Date()
            let _recordingItem = CJAudioItem()
            _recordingItem.bean(from: [kModelDate: _date,
                                       kModelFileName: _date.timeStamp()])
            _iRecorder.start(with: _recordingItem.filePath)
            self.currentRecordingItem = _recordingItem
            _startRecordTimer()
            
            _delegates.forEach {
                $0.audioAgent(self, startToRecord: _recordingItem)
            }
        } catch {
            print("Audio session set to record mode failed! " + error.localizedDescription)
            return
        }
    }
    
    public func stopRecording() {
        if _iRecorder.isRecording {
            let _duration = _iRecorder.stop()
            self.currentRecordingItem?.duration = _duration
            _insert(audioItem: self.currentRecordingItem)
            _stopRecordTimer()
            
            if let _recordingItem = self.currentRecordingItem {
                _delegates.forEach {
                    $0.audioAgent(self, finishRecording: _recordingItem)
                }
            }
            self.currentRecordingItem = nil
        }
    }
}

// MARK: player
extension CJAudioAgent {
    
    public func play(item: CJAudioItem) {
        if let _currentPlayingItem = self.currentPlayingItem,
            _currentPlayingItem.beanIdentity == item.beanIdentity {
            _iPlayer.resume()
            return
        }
        
        self.stopRecording()
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            self.currentPlayingItem = item
            _iPlayer.startToPlay(with: item.filePath)
        } catch {
            print("Audio session set to playback mode failed! " + error.localizedDescription)
            return
        }
    }
    
    public func pausePlaying() {
        _iPlayer.pause()
    }
    
    public func resumePlaying() {
        if let _playingItem = self.currentPlayingItem {
            self.play(item: _playingItem)
        }
    }
    
    public func stopPlaying() {
        _iPlayer.stop()
        self.currentPlayingItem = nil
    }
}

// MARK: data
extension CJAudioAgent {
    
    public var recordedItemList: [String] {
        get {
            if let _result: [String] = CJDataManager.shared.data(for: kAllRecords) as? [String] {
                return _result
            } else {
                return [String]()
            }
        }
    }
}

// MARK: delegates register & remove
extension CJAudioAgent {
    
    public func register(recordVolumeLayer: CJBaseRecordVolumeLayer) {
        _recordVolumeLayerArr.append(recordVolumeLayer)
    }
    
    public func remove(recordVolumeLayer: CJBaseRecordVolumeLayer) {
        _recordVolumeLayerArr = _recordVolumeLayerArr.filter { (layer) -> Bool in
            return layer != recordVolumeLayer
        }
    }
    
    public func register(delegate: CJAudioAgentDelegate) {
        _delegates.append(delegate)
    }
    
    public func remove(delegate: CJAudioAgentDelegate) {
        _delegates = _delegates.filter { (del) -> Bool in
            del !== delegate
        }
    }
}

// MARK: player delegate
extension CJAudioAgent {
    
    public func CJAudioPlayer(_ player: CJAudioPlayer, startToPlay filePath: String) {
        if let _currentPlayingItem = self.currentPlayingItem {
            _delegates.forEach {
                $0.audioAgent(self, startToPlay: _currentPlayingItem)
            }
        }
        _startPlayTimer()
    }
    
    public func CJAudioPlayer(_ player: CJAudioPlayer, finishToPlay filePath: String) {
        if let _currentPlayingItem = self.currentPlayingItem {
            _delegates.forEach {
                $0.audioAgent(self, finishPlaying: _currentPlayingItem)
            }
            self.currentPlayingItem = nil
        }
        _stopPlayTimer()
    }
}

// MARK: internal methods
extension CJAudioAgent {
    
    fileprivate func _insert(audioItem: CJAudioItem?) {
        if let _recordedItem = audioItem {
            CJDataManager.shared.set(data: _recordedItem, for: _recordedItem.beanIdentity)
            var _list = self.recordedItemList
            _list.append(_recordedItem.beanIdentity)
            CJDataManager.shared.set(data: _list as NSArray, for: kAllRecords)
        }
    }
    
    // recorder 定时器，监听录音音量
    fileprivate func _startRecordTimer() {
        _recordTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(_actionRecordTimer),
                                            userInfo: nil, repeats: true)
    }
    
    fileprivate func _stopRecordTimer() {
        _recordTimer?.invalidate()
        _recordTimer = nil
    }
    
    private dynamic func _actionRecordTimer() {
        _recordVolumeLayerArr.forEach { (layer) in
            layer.volumeChanged(to: _iRecorder.currentVolume)
        }
    }
    
    // player 定时器，监听播放进度
    fileprivate func _startPlayTimer() {
        _stopPlayTimer()
        _playTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(_actionPlayTimer),
                                          userInfo: nil, repeats: true)
    }
    
    fileprivate func _stopPlayTimer() {
        _playTimer?.invalidate()
        _playTimer = nil
    }
    
    private dynamic func _actionPlayTimer() {
        _delegates.forEach {
            $0.audioAgent(self, update: _iPlayer.currentProgress, total: _iPlayer.duration)
        }
    }
}
