//
//  LocalWeatherViewController.swift
//  UserInterface
//
//  Created by Gustavo Amaral on 10/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import UIKit
import Services

class LocalWeatherViewController: UIViewController {

    private let localWeatherView = LocalWeatherView()
    override func loadView() { view = localWeatherView }
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    private let coordinator: Coordinator<LocalWeatherView.Button> = Services.make(for: LocalWeatherViewController.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localWeatherView.draw()
        localWeatherView.model = .init(temperature: "34 °C", location: "Brasília - DF", appearance: .hot)
        localWeatherView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension LocalWeatherViewController: LocalWeatherViewDelegate {
    func view(_ view: LocalWeatherView, didTouch button: LocalWeatherView.Button) {
        coordinator.present(button, from: self)
    }
}
