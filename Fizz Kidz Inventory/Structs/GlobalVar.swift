//
//  GlobalVar.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 12/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import Foundation

struct Items {
    static var item_names: [String: String] = [:]
    
    static var item_units: [String: String] = [:]
}

struct Locations {
    static var names: [String] =
        [
            "Warehouse",
            "Malvern",
            "Balwyn"
        ]
}
