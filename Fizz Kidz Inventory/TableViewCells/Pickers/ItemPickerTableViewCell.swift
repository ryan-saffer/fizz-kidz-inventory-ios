//
//  ItemPickerTableViewCell.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 11/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit

/// Table cell used for selecting a stock item
class ItemPickerTableViewCell: PickerTableViewCell {
    
    //================================================================================
    // MARK: - Properties
    //================================================================================
    
    override var reuseIdentifier: String? {
        return "itemPickerCell"
    }
    
    //================================================================================
    // MARK: - Methods
    //================================================================================
    
    override func assignPickerDataSource() {
        self.pickerDataSource = ItemPickerViewDataSource()
    }
    
    override func pickerItemSelected(_ sender: UIButton) {
        super.pickerItemSelected(sender)
        
        // tell the owner the item changed, in order to update qty cell
        self.owner.itemChanged(item: self.selectedItem!)
    }
    
    // called when picker stopped on an item
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        super.pickerView(pickerView, didSelectRow: row, inComponent: component)
        
        // tell the owner the item changed, in order to update qty cell
        self.owner.itemChanged(item: self.selectedItem!)
    }
}
