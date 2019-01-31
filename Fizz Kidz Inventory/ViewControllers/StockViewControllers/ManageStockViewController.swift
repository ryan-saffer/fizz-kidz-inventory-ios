//
//  ManageStockViewController.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 12/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit

/// Protocol for any cells that can be 'cleared' once used
protocol ResettableCell {
    /// Clear any selections made
    func resetCell()
}

/// Controller for any views which rearrange stock, such as receiving or moving stock
class ManageStockViewController: UIViewController, LogOutProtocol {
    
    //================================================================================
    // MARK: - Properties
    //================================================================================
    
    /// TableView used to select which items are going where
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logOutIcon: UIImageView!
    
    /// Disables the views UI and shows a spinner in the center
    var spinner: UIView? = nil
    
    //================================================================================
    // MARK: - Methods
    //================================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerTableViewCells()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(logOutTapped))
        self.logOutIcon.addGestureRecognizer(tapRecognizer)
    }
    
    /// Gets cells from xib files and registers as reusable cells for the table view
    func registerTableViewCells() {
        self.tableView.register(ItemPickerTableViewCell.self, forCellReuseIdentifier: "itemPickerCell")
        self.tableView.register(LocationPickerTableViewCell.self, forCellReuseIdentifier: "locationPickerCell")
        self.tableView.register(UINib(nibName: "QtySelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "qtySelectionCell")
    }
    
    /// Log out button target - logs out of Google Sign In and returns to login page
    @objc func logOutTapped(recognizer: UIGestureRecognizer) {
        self.logOut()
    }
    
    /**
    
     Used when an ingredient picker cell item is changed, to update any qty cells 'unit' label
     
     - Parameter item: The name of the item that was selected
     
    */
    func itemChanged(item: String) {
        for cell in self.tableView.visibleCells {
            if let cell = cell as? SelectQtyTableViewCell {
                let itemID = (Items.names as NSDictionary).allKeys(for: item)[0] as! String
                let itemUnit = Items.units[itemID]!
                cell.unitLabel.text = itemUnit
            }
        }
    }
    
    /// Resets all visible resettable cells
    func resetCells() {
        for cell in self.tableView.visibleCells {
            if let cell = cell as? ResettableCell {
                cell.resetCell()
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
        - handler: Completion handler for doing any work after dismissing
 
    */
    func displayAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: handler))
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
