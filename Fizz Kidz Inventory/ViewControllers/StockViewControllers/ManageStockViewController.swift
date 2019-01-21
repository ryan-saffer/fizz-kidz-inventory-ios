//
//  ManageStockViewController.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 12/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit

/// Controller for any views which rearrange stock, such as receiving or moving stock
class ManageStockViewController: UIViewController {
    
    //================================================================================
    // MARK: - Properties
    //================================================================================
    
    /// TableView used to select which items are going where
    @IBOutlet weak var tableView: UITableView!
    
    /// Disables the views UI and shows a spinner in the center
    var spinner: UIView? = nil
    
    //================================================================================
    // MARK: - Methods
    //================================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerTableViewCells()
    }
    
    /// Gets cells from xib files and registers as reusable cells for the table view
    func registerTableViewCells() {
        self.tableView.register(ItemPickerTableViewCell.self, forCellReuseIdentifier: "itemPickerCell")
        self.tableView.register(LocationPickerTableViewCell.self, forCellReuseIdentifier: "locationPickerCell")
        self.tableView.register(UINib(nibName: "QtySelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "qtySelectionCell")
    }
    
    /**
    
     Used when an ingredient picker cell item is changed, to update any qty cells 'unit' label
     
     - Parameter item: The name of the item that was selected
     
    */
    func itemChanged(item: String) {
        for i in 0...tableView.numberOfRows(inSection: 0) {
            if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? SelectQtyTableViewCell {
                let itemID = (Items.item_names as NSDictionary).allKeys(for: item)[0] as! String
                let itemUnit = Items.item_units[itemID]!
                cell.unitLabel.text = itemUnit
            }
        }
    }
    
    /// Disables the UI by displaying a spinner above the current view
    func disableUI() {
        self.spinner = UIViewController.displaySpinner(onView: self.view)
    }
    
    /**
        Re-enables the UI
 
        Cannot be called unless `disableUI()` has been called previously
    */
    func enableUI() {
        UIViewController.removeSpinner(spinner: self.spinner!)
    }
    
    /**
 
    Displays an alert with a single 'Okay' button
    
    Best used for displaying errors
 
    - Parameters:
        - title: The title of the alert
        - message: The message of the alert
 
    */
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//================================================================================
// MARK: - Extensions
//================================================================================

extension ManageStockViewController: UITableViewDelegate {
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
