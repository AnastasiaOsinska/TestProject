//
//  FiltersViewController.swift
//  TestProject
//
//  Created by Anastasiya Osinskaya on 9/5/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    // MARK: - Constants
    
    private struct Constants {
        static let nibName = "FiltersTableViewCell"
        static let cellId = "FiltersTableViewCellID"
        static let buttonName = "backButton"
        static let labelText = "Filters"
        static let numberOfRow = 0
        static let fontSize: CGFloat = 30
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var applyButton: UIButton!
    
    // MARK: - Properties
    
    private var filtersData: Filters?
    let titleLabel = UILabel()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: Constants.nibName, bundle: nil), forCellReuseIdentifier: Constants.cellId)
        let backBTN = UIBarButtonItem(image: UIImage(named: Constants.buttonName), style: .plain, target: navigationController, action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        backBTN.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = "Filters"
        titleLabel.font = .boldSystemFont(ofSize: Constants.fontSize)
        titleLabel.sizeToFit()
        let leftItem = UIBarButtonItem(customView: titleLabel)
        self.navigationItem.rightBarButtonItem = leftItem
    }
    
    // MARK: - Methods
    
    func setUpView(){
        APIManager.shared.getFiltersModel { [weak self] (result) in
            switch result {
            case .success(let filters):
                self?.filtersData = filters
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func applyButtonAction(_ sender: Any) {
        
    }
    
    @objc func checkButtonAction(sender: UIButton) {
        if sender .isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtersData?.drinks.count ?? Constants.numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath) as? FiltersTableViewCell else { return UITableViewCell() }
        guard let result = filtersData?.drinks[indexPath.row] else { return UITableViewCell() }
        cell.filterName.text = result.strCategory
        cell.selectionStyle = .none
        cell.checkButton.addTarget(self, action: #selector(checkButtonAction(sender:)), for: .touchUpInside)
        return cell 
    } 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
