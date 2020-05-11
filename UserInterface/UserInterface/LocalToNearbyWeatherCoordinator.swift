//
//  LocalToNearbyWeatherCoordinator.swift
//  UserInterface
//
//  Created by Gustavo Amaral on 10/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import UIKit

class LocalToNearbyWeatherCoordinator: Coordinator<LocalWeatherView.Button> {
    
    private weak var origin: LocalWeatherViewController?
    
    override func present(_ destination: LocalWeatherView.Button, from origin: UIViewController) {
        guard let origin = origin as? LocalWeatherViewController else {
            assertionFailure("The origin of 'LocalToNearbyWeatherCoordinator' must be of type 'LocalWeatherViewController'.")
            return
        }
        self.origin = origin
        let targetController = NearbyWeatherViewController()
        origin.navigationController?.pushViewController(targetController, animated: true)
    }
    
    override func dismiss() {
        origin?.dismiss(animated: true, completion: nil)
    }
}
