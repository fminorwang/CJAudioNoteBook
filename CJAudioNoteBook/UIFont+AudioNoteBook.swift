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
    class var navigationTitle: UIFont {
        get {
            return UIFont.preferredFont(forTextStyle: .title3)
        }
    }
    
    class var navigationRightButton: UIFont {
        get {
            return UIFont.preferredFont(forTextStyle: .headline)
        }
    }
    
    class var singleLineCellTitle: UIFont {
        get {
            return UIFont.preferredFont(forTextStyle: .caption1)
        }
    }
    
    class var hint: UIFont {
        get {
            return UIFont.preferredFont(forTextStyle: .footnote)
        }
    }
}
