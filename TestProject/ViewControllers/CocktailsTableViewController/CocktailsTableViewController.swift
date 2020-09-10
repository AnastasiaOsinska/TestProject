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
        static let sectionHeaderHeight: CGFloat = 70
        static let fontSize: CGFloat = 30
        static let numberOfRows = 0
    }
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var filters: Filters?
    private var cocktailData: Cocktails?
    private var queryCategories: [APIManager.QueryCategories] = [.beer,.cocktail,.cocoa,.coffeeTea,.homemadeLiqueur,.milkFloatShake,.ordinaryDrink,.otherUnknown,.punchPartydrink,.shot,.softdrinkSoda]
    var rightButton: UIBarButtonItem?
    let titleLabel = UILabel()
    
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
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = Constants.labelText
        titleLabel.font = .boldSystemFont(ofSize: Constants.fontSize)
        titleLabel.sizeToFit()
        let leftItem = UIBarButtonItem(customView: titleLabel)
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    // MARK: - Methods
    
    @objc func buttonAction() {
        navigationController?.pushViewController(FiltersViewController(), animated: true)
    }
    
    func setUpView(){
        APIManager.shared.getCocktailsModel(queryCategories: queryCategories) { [weak self] (result) in
            switch result {
            case .success(let cocktails):
                self?.cocktailData = cocktails
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getImage(indexPath: IndexPath, imageURL: String?){
        ImageLoader.shared.getImage(from: imageURL, completion: { [weak self] (image) in
            DispatchQueue.main.async {
                (self?.tableView.cellForRow(at: indexPath) as? CocktailsTableViewCell)?.cocktailImage.image = image
            }
        })
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cocktailData?.drinks.count ?? Constants.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath) as? CocktailsTableViewCell else { return UITableViewCell() }
        guard let result = cocktailData?.drinks[indexPath.row] else { return UITableViewCell() }
        DispatchQueue.main.async {
            cell.cocktailName.text = result.strDrink
            cell.cocktailImage.image = nil
        }
        getImage(indexPath: indexPath, imageURL: result.strDrinkThumb)
        return cell
    }
}
