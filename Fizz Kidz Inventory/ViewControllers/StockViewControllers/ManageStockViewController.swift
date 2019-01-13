//
//  ManageStockViewController.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 12/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit

class ManageStockViewController: UIViewController {
    
    //================================================================================
    // MARK: - Properties
    //================================================================================
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // spinner
    var spinner: UIView? = nil
    
    //================================================================================
    // MARK: - Methods
    //================================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
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
    
    func disableUI() {
        self.spinner = UIViewController.displaySpinner(onView: self.view)
    }
    
    func enableUI() {
        UIViewController.removeSpinner(spinner: self.spinner!)
    }
    
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
