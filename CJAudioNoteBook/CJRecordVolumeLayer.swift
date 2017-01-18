//
//  CJRecordVolumeLayer.swift
//  CJAudioNoteBook
//
//  Created by fminor on 16/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import UIKit

/**
 简单显示条状音量
 */
class CJRecordVolumeLayer: CJBaseRecordVolumeLayer {
    private let _iVolumeLayer = CALayer()
    
    override init() {
        super.init()
        self.addSublayer(_iVolumeLayer)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var volumeColor: UIColor? {
        get {
            if let _color = _iVolumeLayer.backgroundColor {
                return UIColor(cgColor: _color)
            }
            return nil
        }
        
        set {
            _iVolumeLayer.backgroundColor = newValue?.cgColor
        }
    }
    
    public override func volumeChanged(to value: Float) {
        print("Volume: " + value.description)
        // -160 ~ 0
        var _minValue = -40.0
        var _maxValue = -10.0
        var _currentValue = Double(value);
        
        let _convertToNormal = {(origin: Double) in
            return pow(10.0, origin / 20.0)
        }
        
        _minValue = _convertToNormal(_minValue)
        _maxValue = _convertToNormal(_maxValue)
        _currentValue = _convertToNormal(_currentValue)
        _currentValue = min(_maxValue, _currentValue)
        _currentValue = max(_minValue, _currentValue)
        
        let _ratio = ( _currentValue - _minValue ) / ( _maxValue - _minValue )
        
        _iVolumeLayer.frame = CGRect(x: 0.0, y: 0.0,
                                     width: CGFloat(_ratio) * self.bounds.width,
                                     height: self.bounds.height)
    }
}
