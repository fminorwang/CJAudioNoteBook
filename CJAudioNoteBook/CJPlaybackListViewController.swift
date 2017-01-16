//
//  CJPlaybackListViewController.swift
//  CJAudioNoteBook
//
//  Created by fminor on 14/01/2017.
//  Copyright © 2017 fminor. All rights reserved.
//

import UIKit

private let kPlaybackCellIdent = "kPlaybackCellIdent"

class CJPlaybackListViewController: CJBaseViewController, UITableViewDelegate, UITableViewDataSource {

    fileprivate let _tableView = UITableView()
    fileprivate let _audioItems = CJAudioAgent.shared.recordedItemList
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _tableView.frame = self.view.bounds
        _tableView.delegate = self
        _tableView.dataSource = self
        self.view.addSubview(_tableView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let _audioItem = CJDataManager.shared.data(for: _ident) as? CJAudioItem
        _cell.titleLabel.text = _audioItem?.date.stringOfEntireTime()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let _ident = _audioItems[indexPath.row]
        if let _audioItem = CJDataManager.shared.data(for: _ident) as? CJAudioItem {
            CJAudioAgent.shared.startToPlay(item: _audioItem)
        }
    }
}
