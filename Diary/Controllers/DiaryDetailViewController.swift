//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by Lukas Kasakaitis on 23.07.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

class DiaryDetailViewController: UIViewController {
    
    
    // MARK: - Outlets
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var entryImage: UIImageView!
    @IBOutlet weak var entryDateLabel: UILabel!
    @IBOutlet weak var entryTextview: UITextView!
    @IBOutlet weak var entryLocationButton: UIButton!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup
        setupSaveButton()
    }
    
    // MARK: - Actions
    @IBAction func addBadMood(_ sender: Any) {
    }
    
    @IBAction func addAverageMood(_ sender: Any) {
    }
    
    @IBAction func addGoodMood(_ sender: Any) {
    }
    
    // MARK: - Helper Methods
    
    func setupSaveButton() {
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveEntry))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    
    @objc func saveEntry() {
        print("Save Button")
    }
    
}
