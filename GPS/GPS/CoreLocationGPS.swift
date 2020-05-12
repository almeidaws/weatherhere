//
//  CoreLocationGPS.swift
//  GPS
//
//  Created by Gustavo Amaral on 11/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import Foundation
import Combine
import Models
import CoreLocation
import UIKit

public class CoreLocationGPS: NSObject, GPS {
    
    public typealias Output = Location
    public typealias Failure = GPSError
    public let publisher = PassthroughSubject<Location, GPSError>()
    private let locationManager = CLLocationManager()
    
    public func receive<S>(subscriber: S) where S : Subscriber, GPSError == S.Failure, Output == S.Input {
        publisher.receive(subscriber: subscriber)
    }
    
    public func start() {
        stop()
        guard CLLocationManager.locationServicesEnabled() else {
            publisher.send(completion: .failure(.disabledGlobally))
            return
        }
        
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startMonitoringSignificantLocationChanges()
        } else if CLLocationManager.authorizationStatus() == .denied {
            publisher.send(completion: .failure(.authorizationDenied(.authorizeManually(at: URL(string: UIApplication.openSettingsURLString)!))))
        } else {            
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    public func stop() {
        locationManager.stopMonitoringSignificantLocationChanges()
    }
}

extension CoreLocationGPS: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecent = locations.last else { return }
        let coordinate = mostRecent.coordinate
        let location = Location(latitude: coordinate.latitude, longitude: coordinate.longitude)
        publisher.send(location)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        publisher.send(completion: .failure(.internalError(error)))
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            publisher.send(completion: .failure(.authorizationDenied(.authorizeManually(at: URL(string: UIApplication.openSettingsURLString)!))))
        case .restricted:
            publisher.send(completion: .failure(.authorizationDenied(.doNothing)))
        case .authorizedWhenInUse:
            manager.startMonitoringSignificantLocationChanges()
        case .notDetermined: break
        case .authorizedAlways:
            publisher.send(completion: .failure(.unexpectedAuthorization("\(status)")))
        default:
            publisher.send(completion: .failure(.unexpectedFutureAuthorizationStatus))
        }
    }
}
