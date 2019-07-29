//
//  DiaryEntryFetchedResultsController.swift
//  Diary
//
//  Created by Lukas Kasakaitis on 24.07.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit
import CoreData


class DiaryEntryFetchedResultsController: NSFetchedResultsController<DiaryEntry> {
    
    private let tableView: UITableView
    
    init(fetchedRequest: NSFetchRequest<DiaryEntry>, managedObjectContext: NSManagedObjectContext, sectionNameKeyPath: String?, tableView: UITableView) {
        self.tableView = tableView
        super.init(fetchRequest: DiaryEntry.fetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil)
        self.delegate = self
        tryFetch()
    }
    
    // MARK: - Helper Methods
    func tryFetch() {
        do {
            try performFetch()
        } catch {
            print("Unresolved error: \(error.localizedDescription)")
        }
    }
    
}

/// MARK: - NSFetchedResultsControllerDelegate
/// Apple Documentation: https://developer.apple.com/documentation/coredata/nsfetchedresultscontrollerdelegate
extension DiaryEntryFetchedResultsController: NSFetchedResultsControllerDelegate {
    
    /// Apple Documentation: https://developer.apple.com/documentation/coredata/nsfetchedresultscontrollerdelegate/1622295-controllerwillchangecontent
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    /// Apple Documentation: https://developer.apple.com/documentation/coredata/nsfetchedresultscontrollerdelegate/1622290-controllerdidchangecontent
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            let index = IndexSet(integer: sectionIndex)
            tableView.insertSections(index, with: .right)
        case .delete:
            let index = IndexSet(integer: sectionIndex)
            tableView.deleteSections(index, with: .right)
        case .move, .update:
            let index = IndexSet(integer: sectionIndex)
            tableView.reloadSections(index, with: .right)
        @unknown default:
            tableView.reloadData()
        }
        
    }
    
    /// Apple Documentation: https://developer.apple.com/documentation/coredata/nsfetchedresultscontrollerdelegate/1622296-controller
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .right)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .right)
        case .update, .move:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .right)
        @unknown default:
            tableView.reloadData()
        }
        
    }
    
}
