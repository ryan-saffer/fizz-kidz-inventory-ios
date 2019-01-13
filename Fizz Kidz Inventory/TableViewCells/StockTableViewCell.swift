//
//  StockTableViewCell.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 10/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit

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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(data: [String]) {
        
        self.nameLabel.text = data[1]
        self.qtyLabel.text = data[2]
        self.unitLabel.text = data[3]
        
        let items = Items()
        let qty = Float(data[2])!
        let high = items.qtyLevels[data[0]]!["HIGH"]!
        let low = items.qtyLevels[data[0]]!["LOW"]!
        
        if (qty >= high) {
            self.circleIcon.tintColor = UIColor.green
        } else if (qty > low && qty < high) {
            self.circleIcon.tintColor = UIColor.orange
        } else if (qty <= low) {
            self.circleIcon.tintColor = UIColor.red
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
