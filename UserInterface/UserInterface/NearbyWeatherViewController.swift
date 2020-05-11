//
//  NearbyWeatherViewController.swift
//  UserInterface
//
//  Created by Gustavo Amaral on 10/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import UIKit
import Services

class NearbyWeatherViewController: UIViewController, Drawable {

    private let nearbyWeatherView = NearbyWeatherView()
    override func loadView() { view = nearbyWeatherView }
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    var isDrawn: Bool { navigationController?.navigationBar.tintColor == .clear }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nearbyWeatherView.draw()
        draw()
        let model = NearbyWeatherView.Model(temperature: "18 °C", location: "Brasília - DF", weather: "Cloudy")
        nearbyWeatherView.rows = Array(repeating: model, count: 20)
    }
    
    func stylizeViews() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
    }
}
