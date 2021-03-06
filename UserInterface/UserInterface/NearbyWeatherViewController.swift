//
//  NearbyWeatherViewController.swift
//  UserInterface
//
//  Created by Gustavo Amaral on 10/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import UIKit
import Services
import Combine

class NearbyWeatherViewController: UIViewController, Drawable {

    private let nearbyWeatherView = NearbyWeatherView()
    override func loadView() { view = nearbyWeatherView }
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    var isDrawn: Bool { navigationController?.navigationBar.tintColor == .clear }
    private let viewModel = NearbyWeatherViewModel()
     private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nearbyWeatherView.draw()
        draw()
        startReceivingWeather()
        nearbyWeatherView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.startRetrievingWeather()
        nearbyWeatherView.isLoading = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopRetrievingWeather()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        cancellables.removeAll()
    }
    
    private func startReceivingWeather() {
        viewModel
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    if
                        case let .gps(error) = error,
                        case let .authorizationDenied(flow) = error,
                        case let .authorizeManually(at: url) = flow {
                        if UIApplication.shared.canOpenURL(url) {
                            self.alert(title:"Unable to fetch your current location".localized, message: "Would you like to reactivate it on settings?".localized, no: { }, yes: {
                                UIApplication.shared.open(url)
                            })
                        } else {
                            self.alert(title: "We haven't access to your location.".localized, message: "Please, give access to this app and retry.".localized)
                        }
                    } else {
                        self.alert(error, ok: {  }) { self.startReceivingWeather() }
                    }
                case .finished:
                    self.nearbyWeatherView.isLoading = false
                }
            }) { weathers in
                self.nearbyWeatherView.rows = weathers.map { weather in
                    NearbyWeatherView.Model(temperature: weather.temperature.localizedValue,
                                            location: "\(weather.city) - \(weather.country)",
                                            weather: weather.sky.capitalized)
                }
                self.nearbyWeatherView.isLoading = false
        }.store(in: &cancellables)
    }
    
    func stylizeViews() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
    }
}

extension NearbyWeatherViewController: NearbyWeatherViewDelegate {
    func viewDidRefresh(_ view: NearbyWeatherView) {
        viewModel.startRetrievingWeather()
    }
}
