//
//  LocalWeatherView.swift
//  UserInterface
//
//  Created by Gustavo Amaral on 10/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import UIKit
import SnapKit

class LocalWeatherView: UIView, Drawable {
    
    private weak var temperature: UILabel!
    private weak var location: UILabel!
    private weak var seeNearby: UIButton!
    private weak var retry: UIButton!
    private weak var scrollView: UIScrollView!
    private weak var scrollViewContainer: UIView!
    private weak var background: UIImageView!
    private weak var activityIndicator: UIActivityIndicatorView!
    @Configured(valueKey: "com.almeidaws.WeatherHere.backgroundImage", defaultValue: Model.Image.cool) private var defaultBackgroundImage: Model.Image
    
    var isDrawn: Bool { return temperature != nil }
    var isLoading: Bool {
        get { activityIndicator.isAnimating }
        set {
            if newValue {
                presentActivityIndicator()
            } else {
                hidesActivityIndicator()
            }
        }
    }
    var isInRetry: Bool {
        get { retry.alpha > 0 }
        set {
            if newValue {
                presentRetryButton()
            }
        }
    }
    weak var delegate: LocalWeatherViewDelegate?
    var model: Model? {
        didSet {
            guard let model = model else { return }
            set(model)
        }
    }
    
    private func hidesActivityIndicator() {
        seeNearby.isUserInteractionEnabled = true
        retry.isUserInteractionEnabled = false
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
            self.activityIndicator.stopAnimating()
            self.temperature.alpha = 1
            self.location.alpha = 1
            self.seeNearby.alpha = 1
            self.retry.alpha = 0
        }, completion: nil)
    }
    
    private func presentRetryButton() {
        seeNearby.isUserInteractionEnabled = false
        retry.isUserInteractionEnabled = true
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
            self.activityIndicator.stopAnimating()
            self.temperature.alpha = 0
            self.location.alpha = 0
            self.seeNearby.alpha = 0
            self.retry.alpha = 1
        }, completion: nil)
    }
    
    private func presentActivityIndicator() {
        seeNearby.isUserInteractionEnabled = false
        retry.isUserInteractionEnabled = false
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
            self.activityIndicator.startAnimating()
            self.temperature.alpha = 0
            self.location.alpha = 0
            self.seeNearby.alpha = 0
            self.retry.alpha = 0
        }, completion: nil)
    }
    
    private func set(_ model: Model) {
        temperature.text = model.temperature
        location.text = model.location
        defaultBackgroundImage = model.appearance
        UIView.transition(with: background, duration: 1, options: .transitionCrossDissolve, animations: {
            self.background.image = model.appearance.image
        }, completion: nil)
    }
    
    func makeConstraints() {
        background.snp.makeConstraints { make in
            make.edges.equalTo(snp.edges)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide.snp.edges)
        }
        
        scrollViewContainer.snp.makeConstraints { make in
            make.width.equalTo(safeAreaLayoutGuide.snp.width)
            make.height.equalTo(safeAreaLayoutGuide.snp.height)
            make.top.equalTo(scrollView.snp.top)
            make.leading.equalTo(scrollView.snp.leading)
        }
        
        temperature.snp.makeConstraints { make in
            make.leading.equalTo(scrollViewContainer.snp.leading)
            make.trailing.equalTo(scrollViewContainer.snp.trailing)
            make.centerY.equalTo(scrollViewContainer.snp.centerY).multipliedBy(0.84)
        }
        
        location.snp.makeConstraints { make in
            make.leading.equalTo(scrollViewContainer.snp.leading)
            make.trailing.equalTo(scrollViewContainer.snp.trailing)
            make.top.equalTo(temperature.snp.bottom)
        }
        
        seeNearby.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading)
            make.trailing.equalTo(snp.trailing)
            make.centerY.equalTo(snp.centerY).multipliedBy(1.45).priority(.high)
            make.top.greaterThanOrEqualTo(temperature.snp.bottom).offset(44).priority(.required)
        }
        
        retry.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide.snp.edges)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide.snp.edges)
        }
    }
    
    func stylizeViews() {
        temperature.font = UIFont.preferredFont(forTextStyle: .largeTitle).withSize(60)
        temperature.textColor = .white
        temperature.textAlignment = .center
        temperature.alpha = 0
        
        location.font = UIFont.preferredFont(forTextStyle: .title2).italicSystemFont()
        location.textColor = .white
        location.textAlignment = .center
        location.alpha = 0
        
        seeNearby.setTitleColor(.white, for: .normal)
        seeNearby.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
        seeNearby.alpha = 0
        seeNearby.isUserInteractionEnabled = false
        
        retry.isUserInteractionEnabled = false
        retry.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        retry.setTitleColor(.white, for: .normal)
        retry.alpha = 0
        
        background.contentMode = .scaleAspectFill
        
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        
        activityIndicator.color = .white
    }
    
    func createViewsHierarchy() {
        let background = UIImageView()
        background.image = defaultBackgroundImage.image
        self.background = background
        addSubview(background)
        
        let scrollView = UIScrollView()
        self.scrollView = scrollView
        addSubview(scrollView)
        
        let scrollViewContainer = UIView()
        self.scrollViewContainer = scrollViewContainer
        scrollView.addSubview(scrollViewContainer)
        
        let temperature = UILabel()
        self.temperature = temperature
        scrollViewContainer.addSubview(temperature)
        
        let location = UILabel()
        self.location = location
        scrollViewContainer.addSubview(location)
        
        let seeNearby = UIButton(type: .system)
        seeNearby.setTitle("See Nearby".localized, for: .normal)
        self.seeNearby = seeNearby
        seeNearby.addTarget(self, action: #selector(handleSeeNearby(_:)), for: .touchUpInside)
        addSubview(seeNearby)
        
        let retry = UIButton(type: .system)
        retry.setTitle("Retry".localized, for: .normal)
        self.retry = retry
        retry.addTarget(self, action: #selector(handleRetry(_:)), for: .touchUpInside)
        addSubview(retry)
        
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.activityIndicator = activityIndicator
        addSubview(activityIndicator)
    }
    
    @objc private func handleSeeNearby(_ sender: UIButton) {
        delegate?.view(self, didTouch: .seeNearby)
    }
    
    @objc private func handleRetry(_ sender: UIButton) {
        delegate?.view(self, didTouch: .retry)
    }
    
    struct Model {
        let temperature: String
        let location: String
        let appearance: Image
        
        enum Image: String, Codable {
            case hot
            case cool
            case cold
            
            var image: UIImage {
                let isOld = ceil(UIScreen.main.bounds.width / UIScreen.main.bounds.height) == ceil(375 / 667)
                switch self {
                case .hot: return isOld ? #imageLiteral(resourceName: "Local Weather - Hot - 2.png") : #imageLiteral(resourceName: "Local Weather - Hot.png")
                case .cool: return isOld ? #imageLiteral(resourceName: "Local Weather - Cool - 2.png") : #imageLiteral(resourceName: "Local Weather - Cool.png")
                case .cold: return isOld ? #imageLiteral(resourceName: "Local Weather - Cold - 2.png") : #imageLiteral(resourceName: "Local Weather - Cold.png")
                }
            }
        }
    }
    
    enum Button: Int {
        case seeNearby
        case retry
    }
}

protocol LocalWeatherViewDelegate: AnyObject {
    func view(_ view: LocalWeatherView, didTouch button: LocalWeatherView.Button)
}
