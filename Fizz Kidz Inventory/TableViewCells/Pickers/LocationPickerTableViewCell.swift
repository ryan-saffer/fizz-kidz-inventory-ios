//
//  locationPickerTableViewCell.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 11/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit

class LocationPickerTableViewCell: PickerTableViewCell {

    //================================================================================
    // MARK: - Methods
    //================================================================================
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.pickerDataSource = LocationPickerDataSource()
        self.picker.dataSource = self.pickerDataSource
    }
}
