//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by ROHIT MISHRA on 19/09/23.
//

import UIKit

class ForecastCell: UITableViewCell {
    static let identifier = "ForecastCell"
    
    enum Constants {
        static let emptyString = ""
        static let datePrefix = "Date:"
        static let maxTampPrefix = "Max Temperature(in celsius):"
        static let minTampPrefix = "Min Temperature(in celsius):"
        static let maxWindSpeed = "Max Wind Speed:"
        
        // Constraints constant
        static let minSpace = 3.0
        static let space = 10.0
    }
    
    private let stackView: UIStackView = {
       let view = UIStackView()
        view.axis = .vertical
        view.spacing = Constants.minSpace
        view.alignment = .leading
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dateLabel: UILabel = {
       let label = UILabel()
        label.text = Constants.emptyString
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let maxTempLabel: UILabel = {
       let label = UILabel()
        label.text = Constants.emptyString
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let minTempLabel: UILabel = {
       let label = UILabel()
        label.text = Constants.emptyString
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let maxWindLabel: UILabel = {
       let label = UILabel()
        label.text = Constants.emptyString
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI view constraints
    private func setupUIConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.space),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.space),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - Private methods
private extension ForecastCell {
    func setupUI() {
        backgroundColor = .white
        addSubview(stackView)
        
        let subviews = [dateLabel, maxTempLabel, minTempLabel, maxWindLabel]
        subviews.forEach({
            stackView.addArrangedSubview($0)
        })
        
        setupUIConstraints()
    }
}

// MARK: - Public methods
extension ForecastCell {
    func configure(forecast: ForecastDay) {
        dateLabel.text = "\(Constants.datePrefix) \(forecast.date)"
        maxTempLabel.text = "\(Constants.maxTampPrefix) \(forecast.day.maxTemp)"
        minTempLabel.text = "\(Constants.minTampPrefix)\(forecast.day.minTemp)"
        maxWindLabel.text = "\(Constants.maxWindSpeed) \(forecast.day.maxWind)"
    }
}
