//
//  CJReplayProgressButton.swift
//  CJAudioNoteBook
//
//  Created by fminor on 17/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import UIKit

class CJReplayProgressButton: CJPlayButton {

    private let _progressLayer = CAShapeLayer()
    
    var progressWidth: CGFloat = 4.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if _progressLayer.superlayer == nil {
            self.layer.addSublayer(_progressLayer)
        }
        
        _progressLayer.frame = self.bounds
        _progressLayer.strokeColor = UIColor.theme.cgColor
        _progressLayer.fillColor = UIColor.clear.cgColor
        _progressLayer.path = UIBezierPath(arcCenter: CGPoint(x: self.bounds.size.width / 2,
                                                              y: self.bounds.size.height / 2),
                                           radius: self.bounds.size.width / 2 + self.progressWidth / 2,
                                           startAngle: CGFloat(-M_PI / 2),
                                           endAngle: CGFloat(M_PI * 1.5),
                                           clockwise: true).cgPath
        _progressLayer.lineWidth = self.progressWidth
    }
    
    func update(progress: CGFloat) {
        _progressLayer.opacity = 1.0
        _progressLayer.strokeStart = 0.0
        _progressLayer.strokeEnd = progress
    }
    
    func finishPlaying() {
        _progressLayer.strokeEnd = 1.0
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            self._progressLayer.opacity = 0.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.50) {
            self._progressLayer.strokeEnd = 0.0
        }
    }
}
