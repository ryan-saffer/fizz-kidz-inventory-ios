//
//  GlobalVar.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 12/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import Foundation

struct Items {
    static var itemIds: [String: String] =
        [
            "Bicarb"        : "BICARB",
            "Citric Acid"   : "CIT_ACID",
            "Plates"        : "PLATES"
        ]
    
    static var itemUnits: [String: String] =
        [
            "BICARB"    : "KG",
            "CIT_ACID"  : "KG",
            "PLATES"    : "PCS"
        ]
    
    static var qtyLevels: [String: [String: Float]] =
        [
            "BICARB":
                [
                    "HIGH"  : 50.0,
                    "LOW"   : 20.0
                ],
            "CIT_ACID":
                [
                    "HIGH"  : 40.0,
                    "LOW"   : 15.0
                ],
            "PLATES":
                [
                    "HIGH"  : 1000.0,
                    "LOW"   : 300.0
                ]
        ]
}

struct Locations {
    static var names: [String] =
        [
            "Warehouse",
            "Malvern",
            "Balwyn"
        ]
}
