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
    
    // MARK: - Delegate properties
    weak var delegate: LocationManagerDelegate?
    
    init(delegate: LocationManagerDelegate?) {
        self.delegate = delegate
        super.init()
        manager.delegate = self
    }
    
    var isAuthorized: Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }
    
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
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    typealias CLGeocodeCompletionHandler = ([CLPlacemark]?, Error?) -> Void
    
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            requestLocation()
        }
    }
    
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            delegate?.failedWithError(.unableToFindLocation)
            return
        }
        
        let coordinate = Coordinate(with: location)
        
        delegate?.obtainedCoordinates(coordinate)
    }
    
}
