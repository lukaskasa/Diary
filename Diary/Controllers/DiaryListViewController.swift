//
//  DiaryListViewController.swift
//  Diary
//
//  Created by Lukas Kasakaitis on 23.07.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

class DiaryListViewController: UITableViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Navigation
        setTitle()
        setupCreateButton()
    }
    
    
    
    
    // MARK: Helper Methods
    
    func setTitle() {
        let title = Date().description
        print(title)
        navigationController?.title = title
    }
    
    func setupCreateButton() {
        let pencilImage = UIImage(imageLiteralResourceName: "icn_write_post")
        let editButton = UIBarButtonItem(image: pencilImage, style: .plain, target: self, action: #selector(showDetail))
        editButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = editButton
    }
    
    @objc func showDetail() {
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
}

