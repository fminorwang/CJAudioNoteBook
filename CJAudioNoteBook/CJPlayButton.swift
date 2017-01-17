//
//  CJPlayButton.swift
//  CJAudioNoteBook
//
//  Created by fminor on 17/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import UIKit

enum CJPlayButtonState {
    case pause
    case play
    case playToPause
    case pauseToPlay
    
    case error
}

class CJPlayButton: UIButton {
    
    public var playState = CJPlayButtonState.play
    public var animateDuration = 0.5
    
    fileprivate var _displayLink: CADisplayLink?
    fileprivate var _animateTime: CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setTitle(nil, for: .normal)
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = self.bounds.size.width / 2.0;
        self.layer.borderColor = UIColor.theme.cgColor
    }
    
    func change(to state: CJPlayButtonState) {
        switch (self.playState, state) {
        case (_, .play):
            self.playState = .pauseToPlay
            _startAnimation()
            return
            
        case (_, .pause):
            self.playState = .playToPause
            _startAnimation()
            return
            
        default:
            return
        }
    }
    
    override func draw(_ rect: CGRect) {
        let _context = UIGraphicsGetCurrentContext()
        
        let _pause_inner_width = rect.size.width / 6.0
        let _pause_inner_height = rect.size.width / 2.2
        
        let _play_left_x = rect.size.width / 2.6
        let _play_left_height = _pause_inner_height;
        let _play_right_x = rect.size.width / 1.3
        
        let _middle_x = rect.size.width / 2.0
        let _middle_y = rect.size.height / 2.0
        
        let _pause_left_x = _middle_x - _pause_inner_width / 2.0
        let _pause_right_x = _middle_x + _pause_inner_width / 2.0
        
        _context?.setFillColor(UIColor.theme.cgColor)
        _context?.setStrokeColor(UIColor.theme.cgColor)
        _context?.setLineWidth(1.0)
        
        switch self.playState {
        case .pause:
            _context?.move(to: CGPoint(x: _pause_left_x, y: _middle_y - _pause_inner_height / 2.0))
            _context?.addLine(to: CGPoint(x: _pause_left_x, y: _middle_y + _pause_inner_height / 2.0))
            _context?.strokePath()
            
            _context?.move(to: CGPoint(x: _middle_x + _pause_inner_width / 2.0 , y: _middle_y - _pause_inner_height / 2.0))
            _context?.addLine(to: CGPoint(x: _middle_x + _pause_inner_width / 2.0 , y: _middle_y + _pause_inner_height / 2.0))
            _context?.strokePath()
            
        case .play:
            _context?.move(to: CGPoint(x: _play_left_x, y: _middle_y - _play_left_height / 2.0))
            _context?.addLine(to: CGPoint(x: _play_left_x, y: _middle_y + _play_left_height / 2.0))
            _context?.addLine(to: CGPoint(x: _play_right_x, y: _middle_y))
            _context?.closePath()
            _context?.strokePath()
            
        case .pauseToPlay:
            let t = _animateTime / CGFloat(self.animateDuration)
            
            let _left_x = _interpolate(from: _pause_left_x, to: _play_left_x, at: t)
            let _left_top_y = _middle_y - _pause_inner_height / 2.0
            let _left_bottom_y = _middle_y + _pause_inner_height / 2.0
            
            _context?.move(to: CGPoint(x: _left_x, y: _left_top_y))
            _context?.addLine(to: CGPoint(x: _left_x, y: _left_bottom_y))
            _context?.strokePath()
            
            let _right_start_x = _interpolate(from: _pause_right_x, to: _play_right_x, at: t)
            let _right_end_x = _interpolate(from: _pause_right_x, to: _play_left_x, at: t)
            
            let _right_top_y = _middle_y - _play_left_height / 2.0
            let _right_bottom_y = _middle_y + _play_left_height / 2.0
            
            _context?.move(to: CGPoint(x: _right_start_x, y:_middle_x))
            _context?.addLine(to: CGPoint(x: _right_end_x, y: _right_top_y))
            _context?.strokePath()
            
            _context?.move(to: CGPoint(x: _right_start_x, y:_middle_x))
            _context?.addLine(to: CGPoint(x: _right_end_x, y: _right_bottom_y))
            _context?.strokePath()
            
        case .playToPause:
            let t = _animateTime / CGFloat(self.animateDuration)
            
            let _left_x = _interpolate(from:_play_left_x, to:_pause_left_x , at:t)
            let _left_top_y = _middle_y - _pause_inner_height / 2.0
            let _left_bottom_y = _middle_y + _pause_inner_height / 2.0
            
            _context?.move(to: CGPoint(x: _left_x, y: _left_top_y))
            _context?.addLine(to: CGPoint(x: _left_x, y: _left_bottom_y))
            _context?.strokePath()
            
            let _right_start_x = _interpolate(from: _play_right_x, to: _pause_right_x, at: t)
            let _right_end_x = _interpolate(from: _play_left_x, to: _pause_right_x, at: t)
            
            let _right_top_y = _middle_y - _play_left_height / 2.0
            let _right_bottom_y = _middle_y + _play_left_height / 2.0
            
            _context?.move(to: CGPoint(x: _right_start_x, y:_middle_x))
            _context?.addLine(to: CGPoint(x: _right_end_x, y: _right_top_y))
            _context?.strokePath()
            
            _context?.move(to: CGPoint(x: _right_start_x, y:_middle_x))
            _context?.addLine(to: CGPoint(x: _right_end_x, y: _right_bottom_y))
            _context?.strokePath()
            
        default:
            return
        }
    }
}

// MARK: internal methods
extension CJPlayButton {
    
    fileprivate func _clearTimer() {
        _displayLink?.invalidate()
        _displayLink = nil
    }
    
    fileprivate func _startAnimation() {
        _clearTimer()
        _animateTime = 0.0
        _displayLink = CADisplayLink(target: self, selector: #selector(_update))
        _displayLink?.add(to: RunLoop.main, forMode: .commonModes)
    }
    
    fileprivate dynamic func _update() {
        _animateTime += 1.0 / 60.0
        self.setNeedsDisplay()
        
        if ( _animateTime >= CGFloat(self.animateDuration) ) {
            _clearTimer()
            
            switch self.playState {
            case .pauseToPlay:
                self.playState = .play
            case .playToPause:
                self.playState = .pause
            default:
                return
            }
        }
    }
    
    fileprivate func _interpolate(from start: CGFloat, to end: CGFloat, at t:CGFloat) -> CGFloat {
        return start + ( end - start ) * t
    }
}
