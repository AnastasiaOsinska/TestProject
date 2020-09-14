//
//  CoctailsTableViewController.swift
//  TestProject
//
//  Created by Anastasiya Osinskaya on 9/4/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import UIKit

class CocktailsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Costants
    
    private struct Constants {
        static let nibName = "CocktailsTableViewCell"
        static let cellId = "CocktailsTableViewCellID"
        static let labelText = "Drinks"
        static let loadingTableViewCellName = "loadingTableViewCellName"
        static let sectionHeaderHeight: CGFloat = 70
        static let fontSize: CGFloat = 30
        static let numberOfRows = 0
        static let numberOfRowsInSection: Int = 1
        static let spacingBetweenCells: CGFloat = 40
    }
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var cellModels: [Any] = []
    private var cocktails: [CocktailData] = []
    private var cocktailData: Cocktails?
    private var queryCategories: APIManager.QueryCategories?// = [.beer,.cocktail,.cocoa,.coffeeTea,.homemadeLiqueur,.milkFloatShake,.ordinaryDrink,.otherUnknown,.punchPartydrink,.shot,.softdrinkSoda]
    private var rightButton: UIBarButtonItem?
    private var titleLabel = UILabel()
    private var showLoadingIndicator: Bool = true
    private var loading: Bool = false
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: Constants.nibName, bundle: nil), forCellReuseIdentifier: Constants.cellId)
        rightButton = UIBarButtonItem(image: #imageLiteral(resourceName: "1"), style: .plain, target: self, action: #selector(buttonAction))
        rightButton?.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem  = rightButton
        navigationController?.navigationBar.barTintColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.sectionHeaderHeight = Constants.sectionHeaderHeight
        setupView()
        reloadCellModels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = Constants.labelText
        titleLabel.font = .boldSystemFont(ofSize: Constants.fontSize)
        titleLabel.sizeToFit()
        let leftItem = UIBarButtonItem(customView: titleLabel)
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    // MARK: - Private
    
    private func setupView() {
        tableView.register(LoadingCell.self, forCellReuseIdentifier: Constants.loadingTableViewCellName)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        refreshControl.isHidden = true
        refreshControl.tintColor = .clear
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    private func reloadCellModels(completion: (() -> Void)? = nil) {
        guard !loading else {
            return
        }
        cocktails = []
        cellModels = []
        showLoadingIndicator = true
        loadData()
    }
    
    private func loadData(completion: (() -> Void)? = nil) {
        APIManager.shared.getCocktailsModel(queryCategories: [.beer]) { [weak self] (result) in
            switch result {
            case .success(let cocktails):
                guard let items = cocktails.drinks, let self = self else {
                    return
                }
                guard !items.isEmpty else {
                    self.loading = false
                    self.loadData(completion: completion)
                    return
                }
                self.showLoadingIndicator = true
                self.cocktails.append(contentsOf: items)
                self.buildCellModels(completion: completion)
            case .failure(let error):
                print(error)
            }
            self?.loading = false
        }
    }
    
    private func buildCellModels(completion: (() -> Void)? = nil) {
           cellModels = []
           cellModels.append(contentsOf: cocktails)
           if showLoadingIndicator {
               cellModels.append(LoadingModel())
           }
           refreshControl.endRefreshing()
           tableView.reloadData()
           guard let completion = completion else {
               return
           }
           completion()
       }
    
    private func preloadingState() {
        if cellModels.isEmpty || cocktails.isEmpty {
            if showLoadingIndicator {
                let exist = cellModels.contains { (model) -> Bool in
                    return model is LoadingModel
                }
                if !exist {
                    cellModels.append(LoadingModel())
                }
            }
            tableView.reloadData()
        }
    }
    
    // MARK: - Actions
    
    @objc func refresh(_ sender: AnyObject) {
        reloadCellModels()
    }
    
    @objc func buttonAction() {
        navigationController?.pushViewController(FiltersViewController(), animated: true)
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.numberOfRowsInSection
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.section
        guard index < cellModels.count else {
            return UITableViewCell()
        }
        let model = cellModels[index]
        var cell: UITableViewCell
        switch model {
        case let cocktailModel as CocktailData:
            guard let cocktailCell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath) as? CocktailsTableViewCell else {
                return UITableViewCell() }
            cocktailCell.setup(with: cocktailModel)
            cell = cocktailCell
        case _ as LoadingModel:
            guard let loadingCell = tableView.dequeueReusableCell(withIdentifier: Constants.loadingTableViewCellName, for: indexPath) as? LoadingCell else { return UITableViewCell() }
            loadingCell.color = .white
            loadingCell.selectionStyle = .none
            return loadingCell
        default:
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.clipsToBounds = true
        return cell
    }

    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? CocktailsTableViewCell else { return }
        cell.cocktailImage.kf.cancelDownloadTask()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : Constants.spacingBetweenCells
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == cellModels.count - 1 && showLoadingIndicator {
            loadData()
        }
    }
}
