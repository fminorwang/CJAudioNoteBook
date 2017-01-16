//
//  UIFont+AudioNoteBook.swift
//  CJAudioNoteBook
//
//  Created by fminor on 15/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    open class var navigationTitle: UIFont {
        get {
            return UIFont.preferredFont(forTextStyle: .title3)
        }
    }
    
    open class var navigationRightButton: UIFont {
        get {
            return UIFont.preferredFont(forTextStyle: .caption1)
        }
    }
    
    open class var singleLineCellTitle: UIFont {
        get {
            return UIFont.preferredFont(forTextStyle: .caption1)
        }
    }
}
