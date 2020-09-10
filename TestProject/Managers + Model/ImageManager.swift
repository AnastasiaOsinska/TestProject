//
//  ImageManager.swift
//  TestProject
//
//  Created by Anastasiya Osinskaya on 9/4/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import Foundation
import UIKit

class ImageLoader: UIImageView {
    
    // MARK: - Properties
    
    let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    static let shared = ImageLoader()
    
    // MARK: - Methods
    
    func getImage(from url: String?, completion: @escaping (_ image: UIImage?) -> Void) {
        guard let url = url else { return }
        guard let nameOfImage = URL(string: url)?.lastPathComponent else { return }
        readImage(nameOfImage: nameOfImage) { [weak self] image in
            guard let image = image else {
                self?.loadImage(from: url) { image in
                    guard let image = image else {
                        completion(nil)
                        return
                    }
                    self?.saveImage(nameOfImage: nameOfImage, img: image)
                    completion(image)
                }
                return
            }
            completion(image)
        }
    }
    
    // MARK: - Private API
    
    private func loadImage(from url: String?, completion: @escaping (_ image: UIImage?) -> Void) {
        guard let stringUrl = url else {
            completion(nil)
            return
        }
        guard let url = URL(string: stringUrl) else {
            completion(nil)
            return
        }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                completion(UIImage(data: data))
            }
        }
    }
    
    // MARK: - Save Image
    
    private func saveImage(nameOfImage: String, img: UIImage) {
        let fileURL = directoryURL.appendingPathComponent(nameOfImage)
        if let data = img.pngData() {
            try? data.write(to: fileURL, options: .atomic)
        }
    }
    
    // MARK: - Read Image
    
    private func readImage(nameOfImage: String, completion: @escaping (_ img: UIImage?) -> Void) {
        do {
            let savedData = try Data(contentsOf: directoryURL.appendingPathComponent(nameOfImage))
            completion(UIImage(data: savedData))
        } catch {
            completion(nil)
        }
    }
}
