//
//  Double+AudioNoteBook.swift
//  CJAudioNoteBook
//
//  Created by fminor on 18/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import Foundation

private let MIN_VOLUME = -40.0
private let MAX_VOLUME = -10.0

extension Double {
    var volumeValue: Double {
        get {
            return pow(10.0, self / 20.0)
        }
    }
    
    static var minVolumeValue: Double {
        get {
            return MIN_VOLUME.volumeValue
        }
    }
    
    static var maxVolumeValue: Double {
        get {
            return MAX_VOLUME.volumeValue
        }
    }
    
    var volumeRatio: Double {
        get {
            let _currentValue = self.volumeValue
            let _ratio = ( _currentValue - Double.minVolumeValue ) / ( Double.maxVolumeValue - Double.minVolumeValue )
            return _ratio
        }
    }
}
