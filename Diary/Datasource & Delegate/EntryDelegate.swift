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
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        configureSeparator()
    }
    
    // MARK: - Delegate Methods
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.darkGray
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // MARK: - Helper Methods
    
    func configureSeparator() {
        // Cell Separator
        tableView.estimatedRowHeight = rowHeight
        tableView.separatorColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

}
