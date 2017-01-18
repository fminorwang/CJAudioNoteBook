//
//  CJRecordHintView.swift
//  CJAudioNoteBook
//
//  Created by fminor on 18/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import UIKit

private let HINT_VIEW_CORNER_RADIUS = 10.0 as CGFloat
private let RECORDING_HINT_PADDING = 20.0 as CGFloat

private let GLOBAL_HINT_VIEW_WIDTH = 200.0 as CGFloat
private let GLOBAL_HINT_VIEW_HEIGHT = 120.0 as CGFloat

class CJRecordHintView: UIView {
    
    static let global = CJRecordHintView(frame: CGRect(x: ( UIScreen.main.bounds.width - GLOBAL_HINT_VIEW_WIDTH ) / 2,
                                                       y: ( UIScreen.main.bounds.height - GLOBAL_HINT_VIEW_HEIGHT),
                                                       width: GLOBAL_HINT_VIEW_WIDTH,
                                                       height: GLOBAL_HINT_VIEW_HEIGHT))
    
    private let _hintLabel = UILabel()
    private var _hideTimer: Timer? = nil
    
    class func display(message text: String,
                       until duration: Float? = nil,
                       at center: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2,
                                                    y: UIScreen.main.bounds.height / 2)) {
        global.display(message: text, until: duration, at: center)
    }
    
    public class func hide() {
        global.hide()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.backgroundColor = UIColor.hintViewBackground
        self.layer.cornerRadius = HINT_VIEW_CORNER_RADIUS
        self.alpha = 0.0
        
        _hintLabel.textColor = UIColor.hintViewLabel
        _hintLabel.font = UIFont.hint
        _hintLabel.textAlignment = .center
        _hintLabel.numberOfLines = 0
        self.addSubview(_hintLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        _hintLabel.frame = CGRect(x: RECORDING_HINT_PADDING,
                                  y: 0,
                                  width: self.bounds.width - 2 * RECORDING_HINT_PADDING,
                                  height: self.bounds.height)
    }
    
    func display(message text: String,
                 until duration: Float? = nil,
                 at center: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2,
                                              y: UIScreen.main.bounds.height / 2)) {
        _invalidateHideTimer()
        _hintLabel.text = text
        self.center = center
        if self.superview == nil {
            UIApplication.shared.keyWindow?.addSubview(self)
            UIView.animate(withDuration: CJ_DEFAULT_ANIMATE_DURATION) {
                self.alpha = 1.0
            }
        }
        
        if let _duration = duration {
            _startHideTimer(with: Double(_duration))
        }
    }
    
    func hide() {
        if self.superview == nil {
            return
        }
        
        UIView.animate(withDuration: CJ_DEFAULT_ANIMATE_DURATION, animations: {
            self.alpha = 0.0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    private func _startHideTimer(with interval: TimeInterval) {
        _invalidateHideTimer()
        _hideTimer = Timer.scheduledTimer(timeInterval: interval,
                                          target: self,
                                          selector: #selector(hide),
                                          userInfo: nil, repeats: false)
    }
    
    private func _invalidateHideTimer() {
        _hideTimer?.invalidate()
        _hideTimer = nil
    }
}
