//
//  Int+CJAudioNoteBook.swift
//  CJAudioNoteBook
//
//  Created by fminor on 18/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import Foundation

extension Int {
    var recordingTime: String {
        let _min = self / 60
        let _sec = self % 60
        return String(format: "%02d:%02d", _min, _sec)
    }
}
