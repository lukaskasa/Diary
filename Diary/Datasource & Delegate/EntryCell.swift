//
//  EntryCell.swift
//  Diary
//
//  Created by Lukas Kasakaitis on 23.07.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

class EntryCell: UITableViewCell {
    
    /// Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var moodImageView: UIImageView!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var updatedLabel: UILabel!
    @IBOutlet weak var updatedDateLabel: UILabel!
    @IBOutlet weak var entryLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationStackView: UIStackView!
    
    
    static let reuseIdentifer = "EntryCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
    }
    
}
