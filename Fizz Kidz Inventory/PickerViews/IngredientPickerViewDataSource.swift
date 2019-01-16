//
//  IngredientPickerViewDataSource+Delegate.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 11/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit

class IngredientPickerViewDataSource: PickerViewDataSource {
    
    //================================================================================
    // MARK: - Methods
    //================================================================================
    
    override init() {
        super.init()
        
        // populate data
        self.data = []
        for item in Items.itemIds {
            self.data.append(item.key)
        }
        self.data.sort()
    }
}
