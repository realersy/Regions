//
//  ViewController.swift
//  Regions
//
//  Created by Ersan Shimshek on 30.08.2023.
//

import UIKit

class RegionsViewController: UIViewController {
    //MARK: - Properties
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let regionsTableView = UITableView()
    private var regions: Response?

    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        regionsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        startSpinner()
        NetworkService.shared.getRegions(completion: { [weak self] response in
            self?.regions = response
            DispatchQueue.main.async {
                self?.stopSpinner()
                self?.regionsTableView.reloadData()
            }
        })
        title = "Любимые регионы"
    }
}

//MARK: - TableView Data Source and Delegate
extension RegionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return regions?.brands.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = regionsTableView.dequeueReusableCell(withIdentifier: RegionCell.cellID) as! RegionCell
        cell.config(brand: regions?.brands[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 12
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = DetailsViewController(brand: (regions?.brands[indexPath.row])!)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}


//MARK: Setup
extension RegionsViewController {
    func setup(){
        view.addSubview(regionsTableView)
        regionsTableView.delegate = self
        regionsTableView.dataSource = self
        regionsTableView.register(RegionCell.self, forCellReuseIdentifier: RegionCell.cellID)
        
        regionsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            regionsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            regionsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            regionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            regionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: regionsTableView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: regionsTableView.centerYAnchor)
        ])
    }
    //MARK: Spinner Methods
    private func startSpinner(){
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    private func stopSpinner(){
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}
