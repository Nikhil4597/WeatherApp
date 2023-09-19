//
//  ResultCell.swift
//  WeatherApp
//
//  Created by ROHIT MISHRA on 19/09/23.
//

import UIKit

class ResultCell: UITableViewCell {
    static let identifier = "ResultCell"
    
    enum Constant {
        static let emptyString = ""
        static let minSpace = 2.0
        static let namePrefix = "Name:"
        static let regionPrefix = "Region:"
        static let countryPrefix = "Country:"
    }
    
    private let stackView: UIStackView = {
       let view = UIStackView()
        view.axis = .vertical
        view.spacing = Constant.minSpace
        view.distribution = .fill
        view.alignment = .leading
        return view
    }()
    
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.text = Constant.emptyString
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let regionLabel: UILabel = {
       let label = UILabel()
        label.text = Constant.emptyString
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countryLabel: UILabel = {
       let label = UILabel()
        label.text = Constant.emptyString
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        addSubview(stackView)
        
        let subviews = [nameLabel, regionLabel, countryLabel]
        subviews.forEach({
            stackView.addArrangedSubview($0)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
}

// MARK: - Public methods
extension ResultCell {
    func configure(result: SearchLocationData) {
        nameLabel.text = "\(Constant.namePrefix) \(result.name)"
        regionLabel.text = "\(Constant.regionPrefix) \(result.region)"
        countryLabel.text = "\(Constant.countryPrefix) \(result.country)"
    }
}
