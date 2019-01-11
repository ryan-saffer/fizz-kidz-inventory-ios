//
//  IngredientPickerViewDataSource+Delegate.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 11/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit

class IngredientPickerViewDataSource: PickerViewDataSource {
    
    override init() {
        super.init()
        self.data = ["BICARB","CIT_ACID","PLATES"]
    }
}
