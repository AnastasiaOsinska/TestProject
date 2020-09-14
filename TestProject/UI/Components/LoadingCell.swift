//
//  LoadingCell.swift
//  TestProject
//
//  Created by Anastasiya Osinskaya on 9/11/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import UIKit

final class LoadingModel {}

final class LoadingCell: UITableViewCell {
    var color: UIColor? {
        set {
            spinner?.color = .black
        }
        get {
            return spinner?.color
        }
    }
    private var spinner: UIActivityIndicatorView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = false
        addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        spinner.startAnimating()
        self.spinner = spinner
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        spinner?.startAnimating()
    }
}
