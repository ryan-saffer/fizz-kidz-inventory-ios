//
//  ViewController.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 8/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit
import FirebaseFirestore

/// Controls the view for moving stock
class MoveStockViewController: ManageStockViewController {
    
    //================================================================================
    // MARK: - Properties
    //================================================================================
    
    // IBOutlets
    @IBOutlet weak var moveItemsButton: UIButton!
    
    //================================================================================
    // MARK: - Methods
    //================================================================================

    /// Validates the fields before updating the quantities in Firestore
    @IBAction func moveButtonPressed(_ sender: Any) {
        
        let itemCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ItemPickerTableViewCell
        let fromCell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! LocationPickerTableViewCell
        let toCell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! LocationPickerTableViewCell
        let qtyCell = self.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! SelectQtyTableViewCell
        
        // VALIDATE FIELDS
        guard let itemName = itemCell.selectedItem else {
            self.displayAlert(title: "Select item", message: "Tap 'Select' to select the item being received")
            return
        }
        let itemID = (Items.item_names as NSDictionary).allKeys(for: itemName)[0] as! String
        
        guard let from = fromCell.selectedItem else {
            self.displayAlert(title: "Select 'From' location", message: "Tap 'Select' to select the location the item is being moved from")
            return
        }
        guard let to = toCell.selectedItem else {
            self.displayAlert(title: "Select 'To' location", message: "Tap 'Select' to select the location the item is being moved to")
            return
        }
        let qty = Float(qtyCell.qtyTextField.text!) ?? 0
        let unit = qtyCell.unitLabel.text!
        
        if (qty <= 0) {
            displayAlert(title: "Quantity invalid", message: "Change the quantity value and try again")
            return
        }
        
        if (from == to) {
            displayAlert(title: "Locations must be different", message: "Make sure the stock is being moved between two separate locations")
            return
        }
        
        // DISPLAY CONFIRMATION DIALOGUE
        let confirmationAlert = UIAlertController(title: "Confirm move", message: "This will move \(qty) \(unit)s of \(itemName) from \(from) to \(to)", preferredStyle: UIAlertController.Style.alert)
        confirmationAlert.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { (action: UIAlertAction!) in
            self.performMove(itemName: itemName, itemID: itemID, from: from, to: to, qty: qty, unit: unit)
        }))
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(confirmationAlert, animated: true, completion: nil)
    }
    
    /**
     Removes qty from location A and adds it to location B
     
     - Parameters:
        - itemName: the name of the stock item being moved
        - itemID: the ID of the stock item in Firestore
        - from: the location the item is being moved from
        - to: the location the item is being moved to
        - qty: the amount being moved
        - unit: the unit the item is measured in
     */
    func performMove(itemName: String, itemID: String, from: String, to: String, qty: Float, unit: String) {
        
        let firestore: Firestore = Firestore.firestore()
        
        self.disableUI()
        
        let fromRef = firestore.document("\(from.uppercased())/\(itemID)")
        let toRef = firestore.document("\(to.uppercased())/\(itemID)")
        
        firestore.runTransaction({ (transaction, errorPointer) -> Any? in
            let fromDocument: DocumentSnapshot
            let toDocument: DocumentSnapshot
            do {
                try fromDocument = transaction.getDocument(fromRef)
                try toDocument = transaction.getDocument(toRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard let oldFromValue = fromDocument.data()?["QTY"] as? NSNumber else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Unable to retrieve qty from snapshot \(fromDocument)"
                    ]
                )
                errorPointer?.pointee = error
                return nil
            }
            
            guard let oldToValue = toDocument.data()?["QTY"] as? NSNumber else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Unable to retrieve qty from snapshot \(toDocument)"
                    ]
                )
                errorPointer?.pointee = error
                return nil
            }
            
            print("Old From Value: \(oldFromValue)")
            print("Old To Value: \(oldToValue)")
            
            // if not enough stock to perform move, cancel
            if (qty > oldFromValue.floatValue) {
                let error = NSError(
                    domain: "FirestoreLogicDomain",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Not enough stock to perform move"
                    ]
                )
                errorPointer?.pointee = error
                return nil
            }
            
            transaction.updateData(["QTY": oldFromValue.floatValue - qty], forDocument: fromRef)
            transaction.updateData(["QTY": oldToValue.floatValue + qty], forDocument: toRef)
            return nil
            
        }) { (object, error) in
            if let error = error {
                // react to errors accordingly
                if (error.localizedDescription == "Not enough stock to perform move") {
                    self.displayAlert(title: "Not enough stock", message: "No changes made.\nPlease try again")
                } else {
                    self.displayAlert(title: "Something went wrong", message: "No changes made.\n Please try again")
                }
                print("Transaction failed: \(error)")
            } else {
                self.displayAlert(title: "Success!", message: "\(qty) \(unit)s of \(itemName) moved from \(from) to \(to)")
                print("Transaction succesfully commited!")
            }
            self.enableUI()
        }
    }
}

//================================================================================
// MARK: - Extensions
//================================================================================

extension MoveStockViewController: UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemPickerCell") as! ItemPickerTableViewCell
            cell.owner = self
            cell.headerLabel.text = "Item"
            return cell
        } else if (indexPath.row == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "locationPickerCell") as! LocationPickerTableViewCell
            cell.owner = self
            cell.headerLabel.text = "From"
            return cell
        } else if (indexPath.row == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "locationPickerCell") as! LocationPickerTableViewCell
            cell.owner = self
            cell.headerLabel.text = "To"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "qtySelectionCell") as! SelectQtyTableViewCell
            return cell
        }
    }
}
