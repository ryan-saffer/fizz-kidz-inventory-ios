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
    // MARK: - Methods
    //================================================================================
    
    @IBOutlet weak var qtyTextField: UITextField! {
        didSet { qtyTextField?.addDoneToolbar() }
    }
    @IBOutlet weak var unitLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
