//
//  SelectQtyTableViewCell.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 12/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit

class SelectQtyTableViewCell: UITableViewCell {

    //================================================================================
    // MARK: - Parameters
    //================================================================================
    
    /// The text field for accepting qty input
    @IBOutlet weak var qtyTextField: UITextField! {
        didSet { qtyTextField?.addDoneToolbar() }
    }
    @IBOutlet weak var unitLabel: UILabel!
}
