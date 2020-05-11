//
//  AppDelegate.swift
//  UserInterface
//
//  Created by Gustavo Amaral on 10/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import UIKit
import Services
import GPS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerServices()
        return true
    }

    private func registerServices() {
        Services.register(LocalWeatherViewController.self) { LocalToNearbyWeatherCoordinator() }
        Services.register(NearbyWeatherViewController.self) { CoreLocationGPS() }
    }


}

