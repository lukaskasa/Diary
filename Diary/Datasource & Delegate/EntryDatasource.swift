//
//  EntryDatasource.swift
//  Diary
//
//  Created by Lukas Kasakaitis on 24.07.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit
import CoreData

class EntryDatasource: NSObject, UITableViewDataSource {
    
    private let tableView: UITableView
    private let context: NSManagedObjectContext
    private let viewController: UIViewController
    
    enum ResultsLabel {
        case noEntries, noResults
        
        var label: String {
            switch self {
            case .noEntries:
                return "You have no diary entries 🥺"
                
            case .noResults:
                return "No results for the search term ☹️"
            }
        }
    }
    
    lazy var fetchedResultsController: DiaryEntryFetchedResultsController = {
        return DiaryEntryFetchedResultsController(fetchedRequest: DiaryEntry.fetchRequest(), managedObjectContext: self.context, sectionNameKeyPath: "sectionIdentifier", tableView: self.tableView)
    }()
    
    init(tableView: UITableView, context: NSManagedObjectContext, viewController: UIViewController) {
        self.tableView = tableView
        self.context = context
        self.viewController = viewController
        super.init()
    }
    
    func object(at indexPath: IndexPath) -> DiaryEntry {
        return fetchedResultsController.object(at: indexPath)
    }
    
    // MARK: - Datasource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var labelText: String = ResultsLabel.noEntries.label
        if fetchedResultsController.fetchRequest.predicate != nil {
            labelText = ResultsLabel.noResults.label
        }
        if fetchedResultsController.sections?.count == 0 {
            let noMatchesLabel = UILabel(frame: CGRect(x: 0, y: 0, width: viewController.view.bounds.size.width, height: viewController.view.bounds.size.height))
            noMatchesLabel.tag = 100
            noMatchesLabel.text = labelText
            noMatchesLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = noMatchesLabel
            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        } else {
            if let label = viewController.view.viewWithTag(100) as? UILabel {
                label.isHidden = true
            }
            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        }
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionName = fetchedResultsController.sections?[section].name else {
            return nil
        }
        
        return sectionName
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else {
            
            return 0
        }
        
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EntryCell.reuseIdentifer, for: indexPath) as! EntryCell
        
        return configureCell(cell, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let diaryEntry = fetchedResultsController.object(at: indexPath)
        context.delete(diaryEntry)
        context.saveChanges()
    }
    
    // MARK: - Helper Methods
    
    func configureCell(_ cell: EntryCell, at indexPath: IndexPath) -> UITableViewCell {
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
        
        if diaryEntry.rating == 0 {
            cell.moodImageView.image = nil
        }
        
        if diaryEntry.image != nil {
            cell.photoImageView.image = UIImage(data: (diaryEntry.image! as Data))
            cell.photoImageView.contentMode = .scaleAspectFill
        } else {
            cell.photoImageView.image = UIImage(imageLiteralResourceName: "icn_picture")
            cell.photoImageView.contentMode = .center
        }
        
        if diaryEntry.rating != 0 {
            cell.moodImageView.image = Mood(rawValue: diaryEntry.rating)?.image
        }
        
        return cell
    }
    
}
