//
//  CJPlaybackTableViewCell.swift
//  CJAudioNoteBook
//
//  Created by fminor on 16/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import UIKit

class CJPlaybackTableViewCell: UITableViewCell {
    
    public let titleLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.font = UIFont.singleLineCellTitle
        self.titleLabel.textColor = UIColor.singleLineCellTitle
        
        self.contentView.addSubview(self.titleLabel)
        
        let _views = ["titleLabel" : self.titleLabel]
        let _metrics = ["padding" : CJ_PADDING]
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-padding-[titleLabel]|",
                                                                       options: [], metrics: _metrics, views: _views))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[titleLabel]|",
                                                                       options: [], metrics: nil, views: _views))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
