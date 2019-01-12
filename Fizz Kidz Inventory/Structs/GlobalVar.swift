//
//  GlobalVar.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 12/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import Foundation

struct Items {
    var itemIds: [String: String] =
        ["Bicarb": "BICARB",
         "Citric Acid": "CIT_ACID",
         "Plates": "PLATES"]
    
    var itemUnits : [String: String] =
        ["BICARB": "KG",
         "CIT_ACID": "KG",
         "PLATES": "PCS"]
}
