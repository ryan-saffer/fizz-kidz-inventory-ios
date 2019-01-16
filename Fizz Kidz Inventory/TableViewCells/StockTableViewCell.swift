//
//  StockTableViewCell.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 10/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit

/// Table cell used for selecting quantity to receive/move
class StockTableViewCell: UITableViewCell {
    
    //================================================================================
    // MARK: - Properties
    //================================================================================
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var circleIcon: UIImageView!
    
    //================================================================================
    // Mark: - Methods
    //================================================================================
    
    /**
     Sets the labels text and circle icon colour
     
     Must be called after dequeue of cell
     
     - Parameters:
        - itemID: the ID of the stock item in Firestore
        - itemName: the name of the stock item
        - qty: the amount of stock available for the item
        - unit: the unit the item is measured in
    */
    func setData(itemID: String, itemName: String, qty: String, unit: String) {
        
        self.nameLabel.text = itemName
        self.qtyLabel.text = qty
        self.unitLabel.text = unit
        
        let qty = Float(qty)!
        let high = Items.qtyLevels[itemID]!["HIGH"]!
        let low = Items.qtyLevels[itemID]!["LOW"]!
        
        if (qty >= high) {
            self.circleIcon.tintColor = UIColor.green
        } else if (qty > low && qty < high) {
            self.circleIcon.tintColor = UIColor.orange
        } else if (qty <= low) {
            self.circleIcon.tintColor = UIColor.red
        }
    }
}
