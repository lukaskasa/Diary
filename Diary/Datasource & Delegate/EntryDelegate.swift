//
//  EntryDelegate.swift
//  Diary
//
//  Created by Lukas Kasakaitis on 24.07.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

class EntryDelegate: NSObject, UITableViewDelegate {
    
    // MARK: Properties
    private let rowHeight: CGFloat = 155.0
    private let tableView: UITableView
    
    /// Initialize the EntryDelegate Object
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        configureSeparator()
    }
    
    // MARK: - Delegate Methods
    /// Apple documentation: https://developer.apple.com/documentation/uikit/uitableviewdelegate
    
    /// Tells the delegate that the table is about to display the header view for the specified section.
    /// https://developer.apple.com/documentation/uikit/uitableviewdelegate/1614905-tableview
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.darkGray
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    /// Asks the delegate for the editing style of a row at a particular location in a table view.
    /// https://developer.apple.com/documentation/uikit/uitableviewdelegate/1614869-tableview
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // MARK: - Helper Methods
    
    /// Configure the cell separator
    func configureSeparator() {
        tableView.estimatedRowHeight = rowHeight
        tableView.separatorColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

}
