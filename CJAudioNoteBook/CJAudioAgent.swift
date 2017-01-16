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

public class CJAudioAgent {
    
    public static let shared = CJAudioAgent()           // singleton
    
    fileprivate var _iRecorder: CJMeasurableAudioPlayer = CJSimpleRecorder()        // recorder
    fileprivate var _recordTimer: Timer? = nil
    
    fileprivate var _iPlayer: CJAudioPlayer = CJSimplePlayer()      // player
    
    fileprivate var _recordVolumeLayerArr = [CJBaseRecordVolumeLayer]()
    
    public var currentRecordingItem: CJAudioItem?
    public var currentPlayingItem: CJAudioItem?
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
        } catch {
            print("Audio session set to record mode failed! " + error.localizedDescription)
            return
        }
    }
    
    public func stopRecording() {
        if _iRecorder.isRecording {
            _iRecorder.stop()
            _insert(audioItem: self.currentRecordingItem)
            self.currentRecordingItem = nil
            _stopRecordTimer()
        }
    }
}

// MARK: player
extension CJAudioAgent {
    public func startToPlay(item: CJAudioItem) {
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

// MARK: UI related
extension CJAudioAgent {
    public func register(recordVolumeLayer: CJBaseRecordVolumeLayer) {
        _recordVolumeLayerArr.append(recordVolumeLayer)
    }
    
    public func remove(recordVolumeLayer: CJBaseRecordVolumeLayer) {
        _recordVolumeLayerArr = _recordVolumeLayerArr.filter { (layer) -> Bool in
            layer != recordVolumeLayer
        }
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
}
