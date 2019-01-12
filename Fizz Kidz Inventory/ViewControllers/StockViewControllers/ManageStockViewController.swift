//
//  ManageStockViewController.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 12/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit

class ManageStockViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    // use when a ingredient picker cell is changed, to update any qty cells
    func itemChanged(item: String) {
        for i in 0...tableView.numberOfRows(inSection: 0) {
            if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? SelectQtyTableViewCell {
                let items = Items()
                let itemID = items.itemIds[item]!
                let itemUnit = items.itemUnits[itemID]!
                cell.unitLabel.text = itemUnit
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
