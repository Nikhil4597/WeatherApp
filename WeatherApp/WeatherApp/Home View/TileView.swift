//
//  TileView.swift
//  WeatherApp
//
//  Created by ROHIT MISHRA on 19/09/23.
//

import UIKit

class TileView: UIView {
    enum Constants {
        static let emptyString = ""
        static let currentLocationTitle = "Your location:"
        static let countryLabel = "Country:"
        static let timezoneLabel = "Current time-zone:"
        static let temperatureLabel = "Current temperature(in celcus):"
        static let windSpeedLabel = "Current wind-speed:"
        static let humidityLabel = "Current humidity:"
        
        // Constraints contant
        static let space = 5.0
        static let normalTextSize = 20.0
        static let largeTextSize = 24.0
    }
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .leading
        view.spacing = Constants.space
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let curretLocationLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.emptyString
        label.font = .systemFont(ofSize: Constants.largeTextSize)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.emptyString
        label.font = .systemFont(ofSize: Constants.normalTextSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timezoneLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.emptyString
        label.font = .systemFont(ofSize: Constants.normalTextSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.emptyString
        label.font = .systemFont(ofSize: Constants.normalTextSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.emptyString
        label.font = .systemFont(ofSize: Constants.normalTextSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.emptyString
        label.font = .systemFont(ofSize: Constants.normalTextSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI view constraints
    private func scrollViewConstraints() {
        let margins = layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.space),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.space),
            scrollView.topAnchor.constraint(equalTo: margins.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
    }
    
    private func stackViewConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
}

// MARK: - Private methods
private extension TileView {
    func setupUI() {
        backgroundColor = .white
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackViewConstraints()
        scrollViewConstraints()
        setupStackView()
    }
    
    func setupStackView() {
        let views = [curretLocationLabel, countryLabel, timezoneLabel, temperatureLabel, windSpeedLabel, humidityLabel]
        
        views.forEach({
            stackView.addArrangedSubview($0)
        })
    }
}

// MARK: - Public methods
extension TileView {
    func updateView(viewModel: TileViewModel) {
        curretLocationLabel.text = "\(Constants.currentLocationTitle) \(viewModel.currentLocationLabel)"
        countryLabel.text = "\(Constants.countryLabel) \(viewModel.countryLabel)"
        timezoneLabel.text = "\(Constants.timezoneLabel) \(viewModel.timezone)"
        temperatureLabel.text = "\(Constants.temperatureLabel) \(viewModel.temperatureLabel)"
        windSpeedLabel.text = "\(Constants.windSpeedLabel) \(viewModel.windSpeedLabel)"
        humidityLabel.text = "\(Constants.humidityLabel) \(viewModel.humidity)"
    }
}
