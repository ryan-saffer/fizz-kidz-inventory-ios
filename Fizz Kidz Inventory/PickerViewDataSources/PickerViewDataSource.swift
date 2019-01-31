//
//  PickerViewDataSource.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 12/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit

class PickerViewDataSource: NSObject, UIPickerViewDataSource {
    
    //================================================================================
    // MARK: - Properties
    //================================================================================
    
    /// Sub-classes must populate this array
    var data: [String]!
    
    //================================================================================
    // MARK: - Methods
    //================================================================================
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.data.count
    }
}
