//
//  CoctailsTableViewController.swift
//  TestProject
//
//  Created by Anastasiya Osinskaya on 9/4/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import UIKit

class CocktailsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var filters: Filters?
    private var cocktailData: Cocktails?
    var rightButton: UIBarButtonItem?
    let titleLabel = UILabel()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CocktailsTableViewCell", bundle: nil), forCellReuseIdentifier: "CocktailsTableViewCellID")
        rightButton = UIBarButtonItem(image: #imageLiteral(resourceName: "1"), style: .plain, target: self, action: #selector(buttonAction))
        rightButton?.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem  = rightButton
        navigationController?.navigationBar.barTintColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.sectionHeaderHeight = 70
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = "Drinks"
        titleLabel.font = .boldSystemFont(ofSize: 30)
        titleLabel.sizeToFit()
        let leftItem = UIBarButtonItem(customView: titleLabel)
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    // MARK: - Methods
    
    @objc func buttonAction() {
        navigationController?.pushViewController(FiltersViewController(), animated: true)
    }
    
    func setUpView(){
        APIManager.shared.getCocktailsModel { [weak self] (result) in
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
        return cocktailData?.drinks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CocktailsTableViewCellID", for: indexPath) as? CocktailsTableViewCell else { return UITableViewCell() }
        guard let result = cocktailData?.drinks[indexPath.row] else { return UITableViewCell() }
        DispatchQueue.main.async {
            cell.cocktailName.text = result.strDrink
            cell.cocktailImage.image = nil
        }
        getImage(indexPath: indexPath, imageURL: result.strDrinkThumb)
        return cell
    }
}
