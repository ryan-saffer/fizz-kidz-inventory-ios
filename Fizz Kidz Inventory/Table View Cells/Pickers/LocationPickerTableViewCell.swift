//
//  locationPickerTableViewCell.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 11/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit

class LocationPickerTableViewCell: PickerTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.pickerDataSource = LocationPickerDataSource()
        self.picker.dataSource = self.pickerDataSource
    }
    
    override func pickerItemSelected(_ sender: UIButton) {
        super.pickerItemSelected(sender)
        
        // alert the table view an item has been selected, in order to update qty cell
        //self.owner.itemDidChange()
    }
}
