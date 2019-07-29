//
//  EntryDetailDatasource.swift
//  Diary
//
//  Created by Lukas Kasakaitis on 27.07.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit
import CoreData

class EntryDetailDatasource: EntryDatasource {
    
    let indexPath: IndexPath?
    
    init(tableView: UITableView, context: NSManagedObjectContext, viewController: UIViewController, indexPath: IndexPath?) {
        self.indexPath = indexPath
        super.init(tableView: tableView, context: context, viewController: viewController)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count > 0 ? 1 : 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EntryCell.reuseIdentifer, for: indexPath) as! EntryCell
        
        if let selectedIndexPath = self.indexPath {
            
            if selectedIndexPath == indexPath {
                cell.isHidden = true
            }
            
        }

        return configureCell(cell, at: indexPath)
    }
    
    override func configureCell(_ cell: EntryCell, at indexPath: IndexPath) -> UITableViewCell {
        let diaryEntry = fetchedResultsController.object(at: indexPath)
        
        let creationDate = diaryEntry.creationDate as Date
        if let updatedDate = diaryEntry.updatedDate as Date? {
            cell.updatedDateLabel.text =  updatedDate.formatDate()
        }
        cell.creationDateLabel.text = creationDate.getReadableWith(weekday: true, day: true, year: false)
        cell.entryLabel.text = diaryEntry.entry
        
        if diaryEntry.location != nil {
            cell.locationLabel.text = diaryEntry.location
            cell.locationStackView.isHidden = false
        } else {
            cell.locationStackView.isHidden = true
        }
        
        if diaryEntry.image != nil {
            cell.photoImageView.image = UIImage(data: (diaryEntry.image! as Data))
            cell.photoImageView.contentMode = .scaleAspectFill
        }
        
        if diaryEntry.rating != 0 {
            cell.moodImageView.image = Mood(rawValue: diaryEntry.rating)?.image
        }
        
        return cell
    }

}
