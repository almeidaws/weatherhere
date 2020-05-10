//
//  LocalWeatherViewController.swift
//  UserInterface
//
//  Created by Gustavo Amaral on 10/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import UIKit

class LocalWeatherViewController: UIViewController {

    private let localWeatherView = LocalWeatherView()
    override func loadView() { view = localWeatherView }
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localWeatherView.draw()
        localWeatherView.model = .init(temperature: "34 °C", location: "Brasília - DF", appearance: .hot)
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
            DispatchQueue.main.async { [weak self] in
                self?.localWeatherView.model = .init(temperature: "34 °C", location: "Brasília - DF", appearance: .cold)
            }
        }
    }
}
