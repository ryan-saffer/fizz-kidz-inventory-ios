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
     
     - Parameter data - a dict with the values from firestore
    */
    func setData(_ data: [String: Any]) {
        
        // get the data
        let dispName = data["DISP_NAME"] as! String
        let unit = data["UNIT"] as! String
        let qty = data["QTY"] as! Double
        let high = data["HIGH"] as! Double
        let low = data["LOW"] as! Double
        
        // format and change labels
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedQty = numberFormatter.string(from: NSNumber(floatLiteral: qty))
        self.nameLabel.text = dispName
        self.qtyLabel.text = String(format: formattedQty!)
        self.unitLabel.text = unit
        
        // change circle colour depending on quantity
        if (qty >= high) {
            self.circleIcon.tintColor = UIColor.green
        } else if (qty > low && qty < high) {
            self.circleIcon.tintColor = UIColor.orange
        } else if (qty <= low) {
            self.circleIcon.tintColor = UIColor.red
        }
    }
}
