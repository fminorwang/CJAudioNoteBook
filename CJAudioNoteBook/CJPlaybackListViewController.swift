//
//  CJPlaybackListViewController.swift
//  CJAudioNoteBook
//
//  Created by fminor on 14/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import UIKit

private let kPlaybackCellIdent = "kPlaybackCellIdent"

class CJPlaybackListViewController: CJBaseViewController, UITableViewDelegate, UITableViewDataSource, CJAudioAgentDelegate {

    fileprivate let _tableView = UITableView()
    fileprivate let _audioItems = CJAudioAgent.shared.recordedItemList      // table view data source
    
    fileprivate var _currentPlayingIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "记录"

        _tableView.frame = self.view.bounds
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.separatorStyle = .none
        self.view.addSubview(_tableView)
        
        _updateCurrentPlayingIndex()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CJAudioAgent.shared.register(delegate: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CJAudioAgent.shared.remove(delegate: self)
    }
    
    deinit {
        print("deinit playback list view controller!")
    }
}

// MARK: table view delegate
extension CJPlaybackListViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _audioItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let _cell = tableView.dequeueReusableCell(withIdentifier: kPlaybackCellIdent) {
            return _cell
        }
        return CJPlaybackTableViewCell(style: .default, reuseIdentifier: kPlaybackCellIdent)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let _cell = cell as! CJPlaybackTableViewCell
        let _ident = _audioItems[indexPath.row]
        if let _audioItem = CJDataManager.shared.data(for: _ident) as? CJAudioItem {
            _cell.renderCell(with: _audioItem)
        }
    }
}

// MARK: audio agent delegate
extension CJPlaybackListViewController {
    
    func audioAgent(_ agent: CJAudioAgent, startToPlay item: CJAudioItem) {
        if let _lastCell = _currentPlayingCell() {
            _lastCell.resetToNormalState()
        }
        
        let _ident = item.beanIdentity
        guard let _currentIndex = _audioItems.index(of: _ident) else {
            return
        }
        self._currentPlayingIndex = _currentIndex
        
        guard let _cell = _tableView.cellForRow(at: IndexPath(row: _currentIndex, section: 0)) as? CJPlaybackTableViewCell else {
            return
        }
        _cell.setToPlayingState()
    }
    
    func audioAgent(_ agent: CJAudioAgent, finishPlaying item: CJAudioItem) {
        if let _cell = _currentPlayingCell() {
            _cell.resetToNormalState()
        }
        _currentPlayingIndex = nil
    }
    
    func audioAgent(_ agent: CJAudioAgent, update progress: Double, total duration: Double) {
        if let _cell = _currentPlayingCell() {
            _cell.displayProgressBar(withCurrent: progress, total: duration)
        }
    }
    
    fileprivate func _updateCurrentPlayingIndex() {
        guard let _ident = CJAudioAgent.shared.currentPlayingItem?.beanIdentity else {
            return
        }
        guard let _currentIndex = _audioItems.index(of: _ident) else {
            return
        }
        self._currentPlayingIndex = _currentIndex
    }
    
    private func _currentPlayingCell() -> CJPlaybackTableViewCell? {
        if let _currentIndex = self._currentPlayingIndex {
            return _tableView.cellForRow(at: IndexPath(row: _currentIndex, section: 0)) as? CJPlaybackTableViewCell
        }
        return nil
    }
}
