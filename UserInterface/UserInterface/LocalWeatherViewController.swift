//
//  LocalWeatherViewController.swift
//  UserInterface
//
//  Created by Gustavo Amaral on 10/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import UIKit
import Services
import GPS
import Combine

class LocalWeatherViewController: UIViewController {

    private let localWeatherView = LocalWeatherView()
    override func loadView() { view = localWeatherView }
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    private let coordinator: Coordinator<LocalWeatherView.Button> = Services.make(for: LocalWeatherViewController.self)
    private let gps: GPS = Services.make(for: NearbyWeatherViewController.self)
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localWeatherView.draw()
        localWeatherView.model = .init(temperature: "34 °C", location: "Brasília - DF", appearance: .hot)
        localWeatherView.delegate = self
        handleGPSUpdates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gps.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gps.stop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        cancellables.removeAll()
    }
    
    private func handleGPSUpdates() {
        gps.publisher.sink(receiveCompletion: { completion in
            print(completion)
        }) { (location) in
            print(location)
        }.store(in: &cancellables)
    }
}

extension LocalWeatherViewController: LocalWeatherViewDelegate {
    func view(_ view: LocalWeatherView, didTouch button: LocalWeatherView.Button) {
        coordinator.present(button, from: self)
    }
}
