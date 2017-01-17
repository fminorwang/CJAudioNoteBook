//
//  CJRecordViewController.swift
//  CJAudioNoteBook
//
//  Created by fminor on 14/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import UIKit

private let VOLUME_LAYER_BOTTOM_MARGIN = 50.0
private let VOLUME_LAYER_HEIGHT = 2.0

class CJRecordViewController: CJBaseViewController, CJAudioAgentDelegate {
    
    fileprivate var _recordItem: CJAudioItem? = nil
    
    private let _recordButton = UIButton(type: .custom)
    private let _hintLabel = UILabel()
    fileprivate let _replayButton = CJReplayProgressButton(type: .custom)
    private let _volumeLayer = CJRecordVolumeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "录音"
        self.initRightNavButton(normalTitle: "记录")
        
        _recordButton.translatesAutoresizingMaskIntoConstraints = false
        _recordButton.setImage(UIImage(named: "record_btn"), for: .normal)
        _recordButton.addTarget(self, action: #selector(_actionTouchDownRecordButton), for: .touchDown)
        _recordButton.addTarget(self, action: #selector(_actionTouchUpRecordButton), for: .touchUpInside)
        _recordButton.addTarget(self, action: #selector(_actionTouchUpRecordButton), for: .touchUpOutside)
        self.view.addSubview(_recordButton)
        
        _hintLabel.translatesAutoresizingMaskIntoConstraints = false
        _hintLabel.textColor = UIColor.text
        _hintLabel.font = UIFont.hint
        _hintLabel.text = "按下按钮开始录音，放开按钮结束录音"
        self.view.addSubview(_hintLabel)
        
        _replayButton.translatesAutoresizingMaskIntoConstraints = false
        _replayButton.layer.borderWidth = 0.5
        _replayButton.update(progress: 0.0)
        _replayButton.alpha = 0.0
        _replayButton.addTarget(self, action: #selector(_actionToggleReplayButton), for: .touchUpInside)
        self.view.addSubview(_replayButton)
        
        _volumeLayer.frame = CGRect(x: 0.0,
                                    y: self.view.bounds.height - CGFloat(VOLUME_LAYER_BOTTOM_MARGIN) - CGFloat(VOLUME_LAYER_HEIGHT),
                                    width: self.view.bounds.size.width,
                                    height: CGFloat(VOLUME_LAYER_HEIGHT))
        _volumeLayer.volumeColor = UIColor.theme
        self.view.layer.addSublayer(_volumeLayer)
        
        let _views = ["_recordButton"   : _recordButton as UIView,
                      "_hintLabel"      : _hintLabel as UIView,
                      "_replayButton"   : _replayButton as UIView]
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-200.0-[_recordButton(64.0)]-30.0-[_hintLabel]-30.0-[_replayButton(64.0)]",
            options: [.alignAllCenterX], metrics: nil, views: _views))
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[_recordButton(64.0)]",
            options: [], metrics: nil, views: _views))
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[_replayButton(64.0)]",
            options: [], metrics: nil, views: _views))
        self.view.addConstraint(NSLayoutConstraint(
            item: _recordButton, attribute: .centerX,
            relatedBy: .equal,
            toItem: self.view, attribute: .centerX,
            multiplier: 1.0, constant: 0.0))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CJAudioAgent.shared.register(recordVolumeLayer: _volumeLayer)
        CJAudioAgent.shared.register(delegate: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        CJAudioAgent.shared.remove(recordVolumeLayer: _volumeLayer)
        CJAudioAgent.shared.remove(delegate: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: actions
extension CJRecordViewController {
    fileprivate dynamic func _actionTouchDownRecordButton() {
        CJAudioAgent.shared.startToRecord()
    }
    
    fileprivate dynamic func _actionTouchUpRecordButton() {
        CJAudioAgent.shared.stopRecording()
    }
    
    fileprivate dynamic func _actionToggleReplayButton() {
        guard let _currentRecordItem = _recordItem else {
            return
        }
        
        if CJAudioAgent.shared.isPlaying(audioItem: _currentRecordItem) {
            CJAudioAgent.shared.pausePlaying()
            _replayButton.change(to: .play)
        } else {
            CJAudioAgent.shared.play(item: _currentRecordItem)
            _replayButton.change(to: .pause)
        }
    }
    
    override func actionClickRightNavButton() {
        let _playbackVC = CJPlaybackListViewController()
        self.navigationController?.pushViewController(_playbackVC, animated: true)
    }
}

// MARK: audio agent delegate
extension CJRecordViewController {
    
    func audioAgent(_ agent: CJAudioAgent, finishRecording item: CJAudioItem) {
        _recordItem = item;
        
        _replayButton.update(progress: 0.0)
        UIView.animate(withDuration: 0.25) {
            self._replayButton.alpha = 1.0
        }
    }
    
    func audioAgent(_ agent: CJAudioAgent, update progress: Double, total duration: Double) {
        guard let _current = _recordItem else {
            return
        }
        if CJAudioAgent.shared.isPlaying(audioItem: _current) {
            _replayButton.update(progress: CGFloat(progress / duration))
        }
    }
    
    func audioAgent(_ agent: CJAudioAgent, finishPlaying item: CJAudioItem) {
        if let _current = _recordItem,
            _current.beanIdentity == item.beanIdentity {
            _replayButton.update(progress: 0.0)
            _replayButton.change(to: .play)
        }
    }
}
