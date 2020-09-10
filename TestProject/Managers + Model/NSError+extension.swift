//
//  NSError+extension.swift
//  TestProject
//
//  Created by Anastasiya Osinskaya on 9/10/20.
//  Copyright © 2020 Anastasiya Osinskaya. All rights reserved.
//

import Foundation

extension NSError {
    static func error(with description: String) -> NSError {
        return NSError(domain: "TestProject", code: -1, userInfo: [NSLocalizedDescriptionKey: description])
    }
}
