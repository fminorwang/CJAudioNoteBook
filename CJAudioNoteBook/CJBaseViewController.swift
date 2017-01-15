//
//  CJBaseViewController.swift
//  CJAudioNoteBook
//
//  Created by fminor on 15/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import UIKit

private let RIGHT_BUTTON_WIDTH = 60.0
private let RIGHT_BUTTON_HEIGHT = 30.0

open class CJBaseViewController: UIViewController {
    
    public var rightNavButton: UIButton?

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.navigationTitle,
            NSForegroundColorAttributeName: UIColor.theme
        ]
    }
    
    open func initRightNavButton(normalTitle: String, selectedTitle: String? = nil) {
        let _button = UIButton(type: .custom)
        _button.frame = CGRect(x: 0.0, y: 0.0,
                               width: RIGHT_BUTTON_WIDTH,
                               height: RIGHT_BUTTON_HEIGHT)
        _button.titleLabel?.font = UIFont.navigationRightButton
        _button.titleLabel?.frame = _button.bounds
        _button.setTitle(normalTitle, for: .normal)
        _button.setTitleColor(UIColor.theme, for: .normal)
        if let _selectedTitle = selectedTitle {
            _button.setTitle(_selectedTitle, for: .selected)
        }
        _button.addTarget(self, action: #selector(actionClickRightNavButton), for: .touchUpInside)
        
        let _buttonItem = UIBarButtonItem(customView: _button)
        self.navigationItem.rightBarButtonItem = _buttonItem
        
        self.rightNavButton = _button
    }
    
    open func actionClickRightNavButton() {
        
    }
}
