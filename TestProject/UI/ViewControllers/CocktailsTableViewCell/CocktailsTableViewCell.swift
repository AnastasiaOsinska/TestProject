//
//  CoctailsTableViewCell.swift
//  TestProject
//
//  Created by Anastasiya Osinskaya on 9/4/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import UIKit

class CocktailsTableViewCell: UITableViewCell {
    
    // MARK: - Constants
    
    private struct Constants {
        static let standartAnimationDuration: Double = 0.4
        static let standartNumberOfLines = 3
        static let backgroundViewRadius: CGFloat = 10
        static let placeholderImageName = "PlaceholderImage"
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var cocktailImage: UIImageView!
    @IBOutlet weak var cocktailName: UILabel!    
    
    // MARK: - Setup
    
    func setup(with model: CocktailData) {
        cocktailName.text = model.strDrink
        setupImage(with: model.strDrinkThumb)
    }
    
    // MARK: - Private
    
    private func setupImage(with url: String?) {
        cocktailImage.image = nil
        guard let stringUrl = url, let url = URL(string: stringUrl) else {
            cocktailImage.image = UIImage(named: Constants.placeholderImageName)
            return
        }
        cocktailImage.kf.setImage(with: url)
    }
}
