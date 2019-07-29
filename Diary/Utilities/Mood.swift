//
//  Mood.swift
//  Diary
//
//  Created by Lukas Kasakaitis on 25.07.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit

enum Mood: Int16 {
    case bad = 1, average = 2, good = 3
    
    var image: UIImage {
        switch self {
        case .bad:
            return UIImage(imageLiteralResourceName: "icn_bad")
        case .average:
            return UIImage(imageLiteralResourceName: "icn_average")
        case .good:
            return UIImage(imageLiteralResourceName: "icn_happy")
        }
    }
}
