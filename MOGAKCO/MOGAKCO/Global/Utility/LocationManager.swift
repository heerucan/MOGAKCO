//
//  LocationManager.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/18.
//

import Foundation

import Then
import CoreLocation

final class LocationManager {
    static let shared = LocationManager().locationManager
    private init() { }
    
    private let locationManager = CLLocationManager().then {
        $0.distanceFilter = 10000
    }
    
    static let myLatitude = LocationManager.shared.location?.coordinate.latitude
    static let myLongtitude = LocationManager.shared.location?.coordinate.longitude
    
    static func coordinate() -> CLLocationCoordinate2D {
        if let latitude = LocationManager.myLatitude,
           let longtitude = LocationManager.myLongtitude {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        } else {
            return CLLocationCoordinate2D(latitude: Matrix.ssacLat, longitude: Matrix.ssacLong)
        }
    }
}
