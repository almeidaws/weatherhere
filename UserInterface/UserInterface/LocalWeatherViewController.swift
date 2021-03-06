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
import Models

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
        reinstallWeatherReceiver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.startRetrievingWeather()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopRetrievingWeather()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        cancellables.removeAll()
    }
    
    private func reinstallWeatherReceiver() {
        localWeatherView.isLoading = true
        viewModel
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    if
                        case let .gps(error) = error,
                        case let .authorizationDenied(flow) = error,
                        case let .authorizeManually(at: url) = flow {
                        if UIApplication.shared.canOpenURL(url) {
                            self.alert(title:"Unable to fetch your current location".localized, message: "Would you like to reactivate it on settings?".localized, no: {
                                self.localWeatherView.isInRetry = true
                            }, yes: {
                                UIApplication.shared.open(url)
                            })
                        } else {
                            self.alert(title: "We haven't access to your location.".localized, message: "Please, give access to this app and retry.".localized)
                            self.localWeatherView.isInRetry = true
                        }
                    } else {
                        self.alert(error, ok: { self.localWeatherView.isInRetry = true }) { self.reinstallWeatherReceiver() }
                    }
                case .finished:
                    self.localWeatherView.isLoading = false
                }
            }) { weather in
                self.localWeatherView.isLoading = false
                self.localWeatherView.model = .init(temperature: weather.temperature.localizedValue,
                                                    location: "\(weather.city) - \(weather.country)",
                    appearance: weather.temperature.feelsLike.asModelImage)
        }.store(in: &cancellables)
    }
}

extension LocalWeatherViewController: LocalWeatherViewDelegate {
    func view(_ view: LocalWeatherView, didTouch button: LocalWeatherView.Button) {
        switch button {
        case .retry:
            reinstallWeatherReceiver()
            viewModel.startRetrievingWeather()
        case .seeNearby:
            coordinator.present(button, from: self)
        }
    }
}

fileprivate extension Weather.Temperature.FeelsLike {
    var asModelImage: LocalWeatherView.Model.Image {
        switch self {
        case .hot: return .hot
        case .cool: return .cool
        case .cold: return .cold
        }
    }
}
