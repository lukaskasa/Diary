//
//  EntryDetailDelegate.swift
//  Diary
//
//  Created by Lukas Kasakaitis on 27.07.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

class EntryDetailDelegate: EntryDelegate {
    
    let indexPath: IndexPath?
    
    init(tableView: UITableView, indexPath: IndexPath?) {
        self.indexPath = indexPath
        super.init(tableView: tableView)
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.indexPath == indexPath {
            return 0
        }
        return -1
    }
    
}
