//
//  DiaryListViewController.swift
//  Diary
//
//  Created by Lukas Kasakaitis on 23.07.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit
import CoreData

class DiaryListViewController: UITableViewController {
    
    // MARK: - Properties
    let searchController = UISearchController(searchResultsController: nil)
    
    let managedObjectContext = CoreDataManager(modelName: "Diary").managedObjectContext
    
    lazy var delegate: EntryDelegate = {
        return EntryDelegate(tableView: self.tableView)
    }()
    
    lazy var dataSource: EntryDatasource = {
        return EntryDatasource(tableView: self.tableView, context: self.managedObjectContext, viewController: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        setTitle()
        setupCreateButton()
        setupSearchBar()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newEntry" {
            let diaryDetailViewController = segue.destination as! DiaryDetailViewController
            diaryDetailViewController.managedObjectContext = self.managedObjectContext
        } else if segue.identifier == "showDetail" {
            guard let diaryDetailViewController = segue.destination as? DiaryDetailViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            let entry = dataSource.object(at: indexPath)
            diaryDetailViewController.indexPath = tableView.indexPathForSelectedRow
            diaryDetailViewController.managedObjectContext = self.managedObjectContext
            diaryDetailViewController.diaryEntry = entry
        }
    }
    
    // MARK: Helper Methods
    
    func setTitle() {
        let title = Date().getReadableWith(weekday: false, day: true, year: true)
        self.title = title
    }
    
    func setupCreateButton() {
        let pencilImage = UIImage(imageLiteralResourceName: "icn_write_post")
        let editButton = UIBarButtonItem(image: pencilImage, style: .plain, target: self, action: #selector(showDetail))
        editButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = editButton
    }
    
    func setupSearchBar() {
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.placeholder = "Search your diary entries"
        searchController.searchBar.barStyle = .default
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }
    
    @objc func showDetail() {
        // Perform multiple entries for one day
        performSegue(withIdentifier: "newEntry", sender: self)
    }
    
}

extension DiaryListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    // MARK: - Delegate methods
    
    func updateSearchResults(for searchController: UISearchController) {

        guard let searchTerm = searchController.searchBar.text else { return }

        if !searchTerm.isEmpty {
            filterResults(searchTerm)
        } else {
            reloadData()
        }
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        reloadData()
    }
    
    // MARK: - Helper methods
    
    func filterResults(_ searchText: String) {
        let predicate: NSPredicate? = NSPredicate(format: "(entry contains [cd] %@) || (location contains [cd] %@)", searchText, searchText)
        dataSource.fetchedResultsController.fetchRequest.predicate = predicate
        dataSource.fetchedResultsController.tryFetch()
        tableView.reloadData()
    }
    
    func reloadData() {
        dataSource.fetchedResultsController.fetchRequest.predicate = nil
        dataSource.fetchedResultsController.tryFetch()
        tableView.reloadData()
    }
    
}
