//
//  LocationManager.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/18.
//

import Foundation

import CoreLocation

final class LocationManager {
    static let shared = LocationManager().manager
    private init() { }
    let manager = CLLocationManager()
    
    static let lat = LocationManager.shared.location?.coordinate.latitude
    static let lng = LocationManager.shared.location?.coordinate.longitude
    
    static func coordinate() -> CLLocationCoordinate2D {
        if let latitude = lat,
           let longtitude = lng {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        } else {
            return CLLocationCoordinate2D(latitude: Matrix.ssacLat, longitude: Matrix.ssacLong)
        }
    }
}
