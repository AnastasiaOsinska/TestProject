//
//  FiltersDataModel.swift
//  TestProject
//
//  Created by Anastasiya Osinskaya on 9/5/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import Foundation

final class Filters: Codable {
    var drinks: [FiltersData]
}

final class FiltersData: Codable {
    var strCategory : String?
}
