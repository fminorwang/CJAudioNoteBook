//
//  CJRecordViewController.swift
//  CJAudioNoteBook
//
//  Created by fminor on 14/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import UIKit

class CJRecordViewController: CJBaseViewController {
    
    private let _recordButton = UIButton(type: .custom)
    private let _replayButton = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "录音"
        self.initRightNavButton(normalTitle: "列表")
        
        _recordButton.translatesAutoresizingMaskIntoConstraints = false
        _recordButton.setImage(UIImage(named: "record_btn"), for: .normal)
        _recordButton.addTarget(self, action: #selector(_actionTouchDownRecordButton), for: .touchDown)
        _recordButton.addTarget(self, action: #selector(_actionTouchUpRecordButton), for: .touchUpInside)
        _recordButton.addTarget(self, action: #selector(_actionTouchUpRecordButton), for: .touchUpOutside)
        self.view.addSubview(_recordButton)
        
        let _views = ["_recordButton" : _recordButton]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-200.0-[_recordButton(64.0)]",
                                                                options: [], metrics: nil, views: _views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[_recordButton(64.0)]",
                                                               options: [], metrics: nil, views: _views))
        self.view.addConstraint(NSLayoutConstraint(item: _recordButton, attribute: .centerX,
                                                   relatedBy: .equal,
                                                   toItem: self.view, attribute: .centerX,
                                                   multiplier: 1.0, constant: 0.0))
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
        CJAudioAgent.shared.stopToRecord()
    }
    
    override func actionClickRightNavButton() {
        let _playbackVC = CJPlaybackListViewController()
        self.navigationController?.pushViewController(_playbackVC, animated: true)
    }
}
