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
        
        self.nameLabel.text = data["DISP_NAME"] as? String
        self.qtyLabel.text = String(describing: data["QTY"]!)
        self.unitLabel.text = data["UNIT"] as? String
        
        let qty = data["QTY"] as! Float
        let high = data["HIGH"] as! Float
        let low = data["LOW"] as! Float
        
        if (qty >= high) {
            self.circleIcon.tintColor = UIColor.green
        } else if (qty > low && qty < high) {
            self.circleIcon.tintColor = UIColor.orange
        } else if (qty <= low) {
            self.circleIcon.tintColor = UIColor.red
        }
    }
}
