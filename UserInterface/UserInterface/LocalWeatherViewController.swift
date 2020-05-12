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
    private let viewModel = LocalWeatherViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localWeatherView.draw()
        localWeatherView.delegate = self
        startReceivingWeather()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.startRetrievingWeather()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.stopRetrievingWeather()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        cancellables.removeAll()
    }
    
    private func startReceivingWeather() {
        localWeatherView.isLoading = true
        viewModel
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.alert(error)
                case .finished:
                    self.localWeatherView.isLoading = false
                }
            }) { weather in
                self.localWeatherView.isLoading = false
                self.localWeatherView.model = .init(temperature: weather.temperature.localizedValue,
                                                    location: "\(weather.city) - \(weather.country)",
                                                    appearance: weather.temperature.feelsLike == .hot ? .hot : .cold)
            }.store(in: &cancellables)
    }
}

extension LocalWeatherViewController: LocalWeatherViewDelegate {
    func view(_ view: LocalWeatherView, didTouch button: LocalWeatherView.Button) {
        coordinator.present(button, from: self)
    }
}
