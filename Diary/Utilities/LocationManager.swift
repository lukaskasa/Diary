//
//  LocationManager.swift
//  Diary
//
//  Created by Lukas Kasakaitis on 25.07.19.
//  Copyright © 2019 Lukas Kasakaitis. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationManagerDelegate: class {
    func obtainedCoordinates(_ coordinate: Coordinate)
    func failedWithError(_ error: LocationError)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    // MARK: - Properties
    private var manager = CLLocationManager()
    private var decoder = CLGeocoder()
    weak var delegate: LocationManagerDelegate?
    
    /**
     Initializes the Location Manager
     
     - Parameters:
        - delegate: the LocationManagerDelegate

     - Returns: a location manager
     */
    init(delegate: LocationManagerDelegate?) {
        self.delegate = delegate
        super.init()
        manager.delegate = self
    }
    
    /// Property to store status of location services user permission
    var isAuthorized: Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }
    
    /// Requests the authorization of location services
    func requestLocationAuthorization() throws {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus == .restricted || authorizationStatus == .denied {
            throw LocationError.disallowedByUser
        } else if authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else {
            return
        }
    }
    
    /// Requests the location
    func requestLocation() {
        manager.requestLocation()
    }

    /**
     Gets the place infomation using the latitude and longitude
     
     - Parameters:
        - coordinate: location coordinate
        - completion: completionhandler for the reverseGeocodeLocation closure
     
     - Returns: a location manager
     */
    func getCityFrom(_ coordinate: Coordinate, completionHandler completion: @escaping CLGeocodeCompletionHandler){
        let locale = Locale(identifier: "en_US")
        
        decoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), preferredLocale: locale) { place, error in
            
            if let city = place {
                completion(city, nil)
            }
            
            if error != nil {
                completion(nil, error)
            }
            
        }
    }
    
    
    // MARK: - Delegate Methods
    /// Apple documentation: https://developer.apple.com/documentation/corelocation/cllocationmanagerdelegate
    
    /// Tells the delegate that the authorization status for the application changed.
    /// Apple documentation: https://developer.apple.com/documentation/corelocation/cllocationmanagerdelegate/1423701-locationmanager
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            requestLocation()
        }
    }
    
    /// Tells the delegate that the location manager was unable to retrieve a location value.
    /// Apple documentation: https://developer.apple.com/documentation/corelocation/cllocationmanagerdelegate/1423786-locationmanager
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        guard let error = error as? CLError else {
            return
        }
        
        switch error.code {
        case .locationUnknown, .network:
            delegate?.failedWithError(.unableToFindLocation)
        case .denied:
            delegate?.failedWithError(.disallowedByUser)
        default:
            return
        }
    }
    
    /// Tells the delegate that new location data is available.
    /// Apple documentation: https://developer.apple.com/documentation/corelocation/cllocationmanagerdelegate/1423615-locationmanager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            delegate?.failedWithError(.unableToFindLocation)
            return
        }
        
        let coordinate = Coordinate(with: location)
        
        delegate?.obtainedCoordinates(coordinate)
    }
    
}
