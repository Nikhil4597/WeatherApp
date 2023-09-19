//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by ROHIT MISHRA on 19/09/23.
//

import UIKit

protocol SearchViewDeleagte: AnyObject {
    func resultCellSelected(result: SearchLocationData)
}

class SearchViewController: UIViewController {
    enum Constant {
        static let cellHeight = 80.0
        static let numberOfSection = 1
    }
    
    weak var delegate: SearchViewDeleagte?

    private var results: [SearchLocationData]? = nil {
        didSet {
            DispatchQueue.main.async {[weak self] in
                self?.resultView.reloadData()
            }
        }
    }
    
    private let resultView: UITableView = {
       let tableView = UITableView()
        tableView.register(ResultCell.self, forCellReuseIdentifier: ResultCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resultView.frame = view.bounds
    }
}

// MARK: - Private methods
private extension SearchViewController {
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(resultView)
        resultView.dataSource = self
        resultView.delegate = self
    }
}

// MARK: - Public methods
extension SearchViewController {
    public func configure(results: [SearchLocationData]) {
        self.results = results
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        Constant.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultCell.identifier, for: indexPath) as? ResultCell else {
            return UITableViewCell()
        }
        
        guard let result = results?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configure(result: result)
        
        return  cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constant.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let result = results?[indexPath.row] else {
            return
        }
        
        delegate?.resultCellSelected(result: result)
    }
}
