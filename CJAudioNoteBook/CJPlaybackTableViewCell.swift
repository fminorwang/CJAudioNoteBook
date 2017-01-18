//
//  CJPlaybackTableViewCell.swift
//  CJAudioNoteBook
//
//  Created by fminor on 16/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import UIKit

private let PLAY_BTN_WH = 30.0
private let PROGRESS_BAR_HEIGHT = 2.0

class CJPlaybackTableViewCell: UITableViewCell {
    
    public var isPlaying = false
    public var audioItem: CJAudioItem? = nil
    
    public let titleLabel = UILabel()
    public let durationLabel = UILabel()
    public let progressBar = UIProgressView()
    public let playButton = CJPlayButton()
    private let separator = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.font = UIFont.singleLineCellTitle
        self.titleLabel.textColor = UIColor.singleLineCellTitle
        self.contentView.addSubview(self.titleLabel)
        
        self.durationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.durationLabel.font = UIFont.singleLineCellTitle
        self.durationLabel.textColor = UIColor.singleLineCellTitle
        self.durationLabel.textAlignment = .right
        self.contentView.addSubview(self.durationLabel)
        
        self.playButton.translatesAutoresizingMaskIntoConstraints = false
        self.playButton.animateDuration = 0.25
        self.playButton.addTarget(self, action: #selector(_actionTogglePlayButton), for: .touchUpInside)
        self.contentView.addSubview(self.playButton)
        
        self.progressBar.translatesAutoresizingMaskIntoConstraints = false
        self.progressBar.progressTintColor = UIColor.theme
        self.progressBar.trackTintColor = UIColor.clear
        self.progressBar.alpha = 0.0
        self.contentView.addSubview(self.progressBar)
        
        self.separator.translatesAutoresizingMaskIntoConstraints = false
        self.separator.backgroundColor = UIColor.sepatator
        self.contentView.addSubview(self.separator)
        
        let _views = ["titleLabel"      : self.titleLabel as UIView,
                      "progressBar"     : self.progressBar as UIView,
                      "playButton"      : self.playButton as UIView,
                      "durationLabel"   : self.durationLabel as UIView,
                      "sepline"         : self.separator]
        let _metrics = ["padding"   : CJ_PADDING,
                        "pb_wh"     : PLAY_BTN_WH,
                        "pgs_h"     : PROGRESS_BAR_HEIGHT]
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-padding-[titleLabel]-[durationLabel]-padding-[playButton(pb_wh)]-padding-|",
            options: [.alignAllCenterY], metrics: _metrics, views: _views))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[titleLabel]|",
            options: [], metrics: nil, views: _views))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[durationLabel]|",
            options: [], metrics: nil, views: _views))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[playButton(pb_wh)]",
            options: [], metrics: _metrics, views: _views))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[progressBar]|",
            options: [], metrics: _metrics, views: _views))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[progressBar(pgs_h)]-0-[sepline(0.5)]|",
            options: [], metrics: _metrics, views: _views))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[sepline]|",
            options: [], metrics: _metrics, views: _views))
    }
    
    override func prepareForReuse() {
        self.audioItem = nil
        self.resetToNormalState()
    }
    
    public func renderCell(with audioItem: CJAudioItem) {
        self.audioItem = audioItem
        self.titleLabel.text = audioItem.date.stringOfEntireTime()
        self.durationLabel.text = String(format: "%.01f秒", audioItem.duration)
        if let _currentPlayingItem = CJAudioAgent.shared.currentPlayingItem,
            _currentPlayingItem.beanIdentity == audioItem.beanIdentity {
            self.setToPlayingState()
        }
    }
    
    public func resetToNormalState() {
        self.titleLabel.textColor = UIColor.singleLineCellTitle
        self.durationLabel.textColor = UIColor.singleLineCellTitle
        self.progressBar.alpha = 0.0
        self.playButton.change(to: .play)
        self.isPlaying = false
    }
    
    public func setToPlayingState() {
        self.titleLabel.textColor = UIColor.theme
        self.durationLabel.textColor = UIColor.theme
        self.progressBar.alpha = 1.0
        self.displayProgressBar(withCurrent: CJAudioAgent.shared.playingProgress,
                                total: CJAudioAgent.shared.playingDuration,
                                animated: false)
        if let _audioItem = audioItem, CJAudioAgent.shared.isPlaying(audioItem: _audioItem) {
            self.playButton.change(to: .pause)
        } else {
            self.playButton.change(to: .play)
        }
        self.isPlaying = true
    }
    
    public func displayProgressBar(withCurrent progress: Double, total duration: Double, animated: Bool = true) {
        guard duration > 0 else {
            return
        }
        let _current = progress / duration;
//        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveLinear], animations: {
        self.progressBar.setProgress(Float(_current), animated: animated)
//        }, completion: nil)
    }
    
    private dynamic func _actionTogglePlayButton() {
        guard let _audioItem = self.audioItem else {
            return
        }
        
        if CJAudioAgent.shared.isPlaying(audioItem: _audioItem) {
            CJAudioAgent.shared.pausePlaying()
            self.playButton.change(to: .play)
        } else {
            CJAudioAgent.shared.play(item: _audioItem)
            self.playButton.change(to: .pause)
        }
    }
}
