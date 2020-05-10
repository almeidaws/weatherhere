//
//  NearbyWeatherViewController.swift
//  UserInterface
//
//  Created by Gustavo Amaral on 10/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import UIKit

class NearbyWeatherViewController: UIViewController {

    private let nearbyWeatherView = NearbyWeatherView()
    override func loadView() { view = nearbyWeatherView }
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nearbyWeatherView.draw()
        
        let model = NearbyWeatherView.Model(temperature: "18 °C", location: "Brasília - DF", weather: "Cloudy")
        nearbyWeatherView.rows = Array(repeating: model, count: 20)
    }
}
