//
//  GlobalVar.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 12/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import Foundation

struct Items {
    // populated from Firestore after login
    static var names: [String: String] = [:]
    static var units: [String: String] = [:]
}

struct Locations {
    static var names: [String] =
        [
            "Warehouse",
            "Malvern",
            "Balwyn"
        ]
}
