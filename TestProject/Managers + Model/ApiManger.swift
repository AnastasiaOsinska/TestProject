//
//  ApiManger.swift
//  TestProject
//
//  Created by Anastasiya Osinskaya on 9/4/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class APIManager {
    
    // MARK: - Constants
    
    private struct Constants {
        static let contentTypeAppJson = ["Content-Type": "application/json"]
        static let wrongMessage = "Something went wrong."
        static let decodeDataMessage = "Can't decode data."
        static let responseCodeMessage = "Response with status code: "
        static let keyCategory = "c"
    }
    
    // MARK: - QueryCategories
    
    enum QueryCategories: String, CaseIterable {
        case ordinaryDrink = "Ordinary Drink"
        case cocktail = "Cocktail"
        case milkFloatShake = "Milk \\/ Float \\/ Shake"
        case otherUnknown = "Other \\/ Unknown"
        case cocoa = "Cocoa"
        case shot = "Shot"
        case coffeeTea = "Coffee \\/ Tea"
        case homemadeLiqueur = "Homemade Liqueur"
        case punchPartydrink = "Punch \\/ Party Drink"
        case beer = "Beer"
        case softdrinkSoda = "Soft Drink \\/ Soda"
    }
    
    // MARK: - URLs
    
    enum URLs {
        static let cocktailsURL = "https://www.thecocktaildb.com/api/json/v1/1/"
        static let filtersURL = "https://www.thecocktaildb.com/api/json/v1/1/"
        static let filter = "filter.php?"
        static let name = "c=Ordinary_Drink"
        static let list = "list.php?"
        static let value = "c=list"
    }
    
    // MARK: - Properties
    
    static let shared = APIManager()
    
    // MARK: - Init
    
    private init() { }
    
    // MARK: - Get Data From Api
    
    func getCocktailsModel(queryCategories: [QueryCategories], completion: @escaping(_ result: Result<Cocktails, Error>) -> Void) {
        let url = URLs.cocktailsURL + URLs.filter
        var categoriesString = ""
        //let queryCategories: [QueryCategories] = [.ordinaryDrink]
        for category in queryCategories {
            categoriesString += "\(category.rawValue),"
        }
        categoriesString.removeLast()
        let queryItem = URLQueryItem(name: Constants.keyCategory, value: categoriesString)
        request(for: url, queryItems: [queryItem], parameters: Constants.contentTypeAppJson, completion: completion)
    }
    
    func getFiltersModel(completion: @escaping(_ result: Result<Filters, Error>) -> Void) {
        let url = URLs.filtersURL + URLs.list + URLs.value
        request(for: url, parameters: Constants.contentTypeAppJson, completion: completion)
    }
    
    // MARK: - Requests
    
    private func request<T: Codable>(for url: String, queryItems: [URLQueryItem], parameters: [String: String] = [:], method: HTTPMethod = .get, completion: @escaping(_ result: Result<T, Error>) -> Void) {
        var urlComp = URLComponents(string: url)
        urlComp?.queryItems = queryItems
        guard var request = try? URLRequest(url: urlComp!.url!, method: method) else {
            let error = NSError.error(with: Constants.wrongMessage)
            completion(.failure(error))
            return
        }
        request.httpMethod = method.rawValue
        request.headers = HTTPHeaders(parameters)
        AF.request(request).responseData { [weak self] (response) in
            guard let self = self else {
                let error = NSError.error(with: Constants.wrongMessage)
                completion(.failure(error))
                return
            }
            completion(self.processResponse(response))
        }
    }
    
    private func request<T: Codable>(for url: String, parameters: [String: String] = [:], method: HTTPMethod = .get, completion: @escaping(_ result: Result<T, Error>) -> Void) {
        guard var request = try? URLRequest(url: url, method: method) else {
            let error = NSError.error(with: Constants.wrongMessage)
            completion(.failure(error))
            return
        }
        request.httpMethod = method.rawValue
        request.headers = HTTPHeaders(parameters)
        AF.request(request).responseData { [weak self] (response) in
            guard let self = self else {
                let error = NSError.error(with: Constants.wrongMessage)
                completion(.failure(error))
                return
            }
            completion(self.processResponse(response))
        }
    }
    
    // MARK: - Helpers
    
    private func processResponse<T: Codable>(_ response: AFDataResponse<Data>) -> Result<T, Error> {
        let result: Result<T, Error> = self.dataDecoder(response.data)
        switch result {
        case .success(let object):
            return .success(object)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    private func dataDecoder<T: Codable>(_ data: Data?) -> Result<T, Error> {
        guard let data = data else {
            return .failure(NSError.error(with: Constants.decodeDataMessage))
        }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(T.self, from: data)
            return .success(object)
        } catch {
            print(error.localizedDescription)
            return .failure(NSError.error(with: Constants.decodeDataMessage))
        }
    }
}
