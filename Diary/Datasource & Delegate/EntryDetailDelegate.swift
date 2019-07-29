//
//  EntryDetailDelegate.swift
//  Diary
//
//  Created by Lukas Kasakaitis on 27.07.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

class EntryDetailDelegate: EntryDelegate {
    
    // MARK: - Properties
    let indexPath: IndexPath?
    
    /// Initialize the EntryDelegate Object
    init(tableView: UITableView, indexPath: IndexPath?) {
        self.indexPath = indexPath
        super.init(tableView: tableView)
    }
    
    /// Asks the delegate for the editing style of a row at a particular location in a table view.
    /// https://developer.apple.com/documentation/uikit/uitableviewdelegate/1614869-tableview
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    /// Asks the delegate for the height to use for a row in a specified location.
    /// Apple documentation: https://developer.apple.com/documentation/uikit/uitableviewdelegate/1614998-tableview
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.indexPath == indexPath {
            return 0
        }
        return -1
    }
    
}
