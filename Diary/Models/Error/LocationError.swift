//
//  LocationError.swift
//  Diary
//
//  Created by Lukas Kasakaitis on 25.07.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import Foundation

enum LocationError: Error {
    case unknownError
    case disallowedByUser
    case unableToFindLocation
}
