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
}
