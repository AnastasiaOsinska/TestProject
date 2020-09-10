//
//  DataModel.swift
//  TestProject
//
//  Created by Anastasiya Osinskaya on 9/4/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import Foundation

final class Cocktails: Codable {
    var drinks: [CocktailData?]
}

final class CocktailData: Codable {
    var strDrink : String?
    var strDrinkThumb : String?
}
