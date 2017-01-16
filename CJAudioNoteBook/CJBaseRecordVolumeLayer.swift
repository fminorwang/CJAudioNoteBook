//
//  CJBaseRecordVolumeLayer.swift
//  CJAudioNoteBook
//
//  Created by fminor on 16/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import UIKit

public class CJBaseRecordVolumeLayer: CALayer {
    public func volumeChanged(to value: Float) {
        // override by subclasses
    }
    
    public func stopRecording() {
        self.volumeChanged(to: -160.0)
    }
}
