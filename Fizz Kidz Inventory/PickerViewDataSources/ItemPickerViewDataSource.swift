//
//  ItemPickerViewDataSource+Delegate.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 11/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit

class ItemPickerViewDataSource: PickerViewDataSource {
    
    //================================================================================
    // MARK: - Methods
    //================================================================================
    
    override init() {
        super.init()
        
        // populate data
        self.data = []
        
        // if no internet, Items.item_names will be empty
        if (Items.item_names.isEmpty) {
            self.data.append("NO INTERNET CONNECTION")
            return
        }
        
        for item in Items.item_names {
            self.data.append(item.value)
        }
        self.data.sort()
    }
}
