//
//  NearbyWeatherView.swift
//  UserInterface
//
//  Created by Gustavo Amaral on 10/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import UIKit

class NearbyWeatherView: UIView, Drawable {

    private weak var tableView: UITableView!
    private weak var background: UIImageView!
    var isDrawn: Bool { tableView != nil }
    
    var rows = [Model]() { didSet { tableView.reloadData() } }
    
    func makeConstraints() {
        background.snp.makeConstraints { make in
            make.edges.equalTo(snp.edges)
        }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide.snp.edges)
        }
    }
    
    func stylizeViews() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        background.image = #imageLiteral(resourceName: "Purple Background.png")
        background.contentMode = .scaleAspectFill
    }
    
    func createViewsHierarchy() {
        let background = UIImageView()
        self.background = background
        addSubview(background)
        
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(Cell.self, forCellReuseIdentifier: cellIdentifier)
        self.tableView = tableView
        addSubview(tableView)
    }
    
    struct Model {
        let temperature: String
        let location: String
        let weather: String
    }
}

extension NearbyWeatherView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let genericCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        guard let cell = genericCell as? Cell else {
            assertionFailure("The cell's type must be 'Cell'.")
            return genericCell
        }
        
        cell.drawIfNeeded()
        let row = rows[indexPath.row]
        cell.model = row
        
        return genericCell
    }
}

extension NearbyWeatherView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
}

fileprivate class Cell: UITableViewCell, Drawable {
    
    private weak var temperature: UILabel!
    private weak var location: UILabel!
    private weak var weather: UILabel!
    
    var isDrawn: Bool { return temperature != nil }
    
    var model: NearbyWeatherView.Model? {
        didSet {
            guard let model = self.model else { return }
            temperature.text = model.temperature
            location.text = model.location
            weather.text = model.weather
        }
    }
  
    func makeConstraints() {
        temperature.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).inset(29)
            make.top.equalTo(snp.top)
            make.trailing.equalTo(weather.snp.leading)
        }
        
        location.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).inset(29)
            make.top.equalTo(temperature.snp.bottom)
            make.trailing.equalTo(weather.snp.leading)
        }
        
        weather.snp.makeConstraints { make in
            make.trailing.equalTo(snp.trailing).inset(29)
            make.top.equalTo(snp.top)
        }
    }
    
    func stylizeViews() {
        temperature.font = UIFont.preferredFont(forTextStyle: .title1).boldSystemFont()
        temperature.textColor = .white
        
        location.font = UIFont.preferredFont(forTextStyle: .title2).italicSystemFont()
        location.textColor = .white
        
        weather.font = UIFont.preferredFont(forTextStyle: .headline).boldSystemFont()
        weather.textColor = .white
        weather.textAlignment = .right
        
        backgroundColor = .clear
    }
    
    func createViewsHierarchy() {
        let temperature = UILabel()
        self.temperature = temperature
        addSubview(temperature)
        
        let location = UILabel()
        self.location = location
        addSubview(location)
        
        let weather = UILabel()
        self.weather = weather
        addSubview(weather)
    }
}

fileprivate let cellIdentifier = "cellIdentifier"
