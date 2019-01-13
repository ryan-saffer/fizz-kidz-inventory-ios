//
//  ItemPickerTableViewCell.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 11/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit

class IngredientPickerTableViewCell: PickerTableViewCell {
    
    //================================================================================
    // MARK: - Methods
    //================================================================================
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.pickerDataSource = IngredientPickerViewDataSource()
        self.picker.dataSource = self.pickerDataSource
    }
    
    // called when picker 'Done' button selected
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
