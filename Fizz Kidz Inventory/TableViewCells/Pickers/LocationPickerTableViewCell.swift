//
//  locationPickerTableViewCell.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 11/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit

/// Table cell used for selecting a store location
class LocationPickerTableViewCell: PickerTableViewCell {

    //================================================================================
    // MARK: - Parameters
    //================================================================================
    
    override var reuseIdentifier: String? {
        return "locationPickerCell"
    }
    
    //================================================================================
    // MARK: - Methods
    //================================================================================
    
    override func assignPickerDataSource() {
        self.pickerDataSource = LocationPickerDataSource()
    }
}
