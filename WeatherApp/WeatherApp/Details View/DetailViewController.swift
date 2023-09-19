//
//  DetailsViewController.swift
//  WeatherApp
//
//  Created by ROHIT MISHRA on 19/09/23.
//

import UIKit

class DetailViewController: UIViewController {
    enum Constants {
        static let title = "Details"
        static let forecastDefaultTitle = "Forecasts:"
        
        // Constraints constant
        static let largeTextSize = 20.0
        static let space = 5.0
        static let tileViewHeight = 200.0
        static let tableViewCellHeight = 100.0
    }
    
    private var viewModel: DetailViewModel = {
        let viewModel = DetailViewModel()
        return viewModel
    }()
    
    private let tileView: TileView = {
        let tileView = TileView()
        tileView.translatesAutoresizingMaskIntoConstraints = false
        return tileView
    }()
    
    private let forecastLabel: UILabel = {
       let label = UILabel()
        label.text = Constants.forecastDefaultTitle
        label.font = .boldSystemFont(ofSize: Constants.largeTextSize)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
       let view = UITableView()
        view.register(ForecastCell.self, forCellReuseIdentifier: ForecastCell.identifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUIConstraints() {
        NSLayoutConstraint.activate([
            tileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.space),
            tileView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.space),
            tileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.space),
            tileView.heightAnchor.constraint(equalToConstant: Constants.tileViewHeight)
        ])
        
        NSLayoutConstraint.activate([
            forecastLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.space),
            forecastLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.space),
            forecastLabel.topAnchor.constraint(equalTo: tileView.bottomAnchor, constant: Constants.space),
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.space),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.space),
            tableView.topAnchor.constraint(equalTo: forecastLabel.bottomAnchor, constant: Constants.space),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.space)
        ])
    }
}

private extension DetailViewController {
    func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = Constants.title
        
        viewModel.delegate = self
        
        view.addSubview(tileView)
        view.addSubview(forecastLabel)
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        setupUIConstraints()
    }
    
    
    
    func updateView() {
        guard let locationData = viewModel.locationData,
              let currentData = viewModel.currentData else{
                return
        }
        let tileViewModel = TileViewModel(currentLocationLabel: locationData.name,
            countryLabel: locationData.country,
            timezone: locationData.timezone,
            temperatureLabel: String(currentData.temperature),
            windSpeedLabel: String(currentData.windSpeed),
            humidity: String(currentData.humidity))
        tileView.updateView(viewModel: tileViewModel)
    }
}

// MARK: - Public methods
extension DetailViewController {
    func configureCityData(cityName: String) {
        DispatchQueue.global().async {[weak self] in
            self?.viewModel.cityName = cityName
            self?.viewModel.getUserWeatherData()
        }
    }
}

// MARK:  DetailViewModelDelegate methods
extension DetailViewController: DetailViewModelDelegate {
    func updateTileView() {
        DispatchQueue.global().async {[weak self] in
            self?.viewModel.getForecastData()
        }
        
        DispatchQueue.main.async {[weak self] in
            self?.updateView()
        }
    }
    
    func updateTableView() {
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCellInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastCell.identifier) as? ForecastCell else {
            return UITableViewCell()
        }
        
        if let forecastData = viewModel.forecastData(at: indexPath.row) {
            cell.configure(forecast: forecastData)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.tableViewCellHeight
    }
}
