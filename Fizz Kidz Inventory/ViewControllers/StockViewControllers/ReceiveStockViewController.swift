//
//  ReveiveStockViewController.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 10/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit
import FirebaseFirestore
import GoogleSignIn

/// Controls the view for receiving stock
class ReceiveStockViewController: ManageStockViewController {
    
    //================================================================================
    // MARK: - Methods
    //================================================================================
    
    /// Validates the fields before updating Firestore
    @IBAction func receiveStockButtonPressed(_ sender: Any) {
        
        let itemCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ItemPickerTableViewCell
        let locationCell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! LocationPickerTableViewCell
        let qtyCell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! SelectQtyTableViewCell
        
        // VALIDATE FIELDS
        guard let itemName = itemCell.selectedItem else {
            self.displayAlert(title: "Select item", message: "Tap 'Select' to select the item being received")
            return
        }
        let itemID = (Items.item_names as NSDictionary).allKeys(for: itemName)[0] as! String
        
        guard let location = locationCell.selectedItem else {
            self.displayAlert(title: "Select Location", message: "Tap 'Select' to select the location the stock is being received")
            return
        }
        let qty = Float(qtyCell.qtyTextField.text!) ?? 0
        let unit = qtyCell.unitLabel.text!
        
        if (qty <= 0) {
            self.displayAlert(title: "Quantity Invalid", message: "Enter a valid quantity and try again")
            return
        }
        
        // DISPLAY CONFIRMATION DIALOGUE
        let confirmationAlert = UIAlertController(title: "Confirm receival", message: "\(qty) \(unit)s of \(itemName) will be received in \(location)", preferredStyle: UIAlertController.Style.alert)
        confirmationAlert.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { (action: UIAlertAction!) in
            self.reveiveStock(itemName: itemName, itemID: itemID, location: location, qty: qty, unit: unit)
        }))
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(confirmationAlert, animated: true, completion: nil)
    }
    
    /**
     Updates Firestore with the amount of stock received
     
     - Parameters:
        - itemName: the name of the stock item being receieved
        - itemID: the ID of the item in Firestore
        - location: the location the item is being received into
        - qty: the amount being received
        - unit: the unit the item is measured in
     */
    func reveiveStock(itemName: String, itemID: String, location: String, qty: Float, unit: String) {
        
        self.disableUI()
        
        let firestore: Firestore = Firestore.firestore()
        let docRef: DocumentReference = firestore.document("\(location.uppercased())/\(itemID)")
        
        firestore.runTransaction({ (transaction, errorPointer) -> Any? in
            let document: DocumentSnapshot
            do {
                try document = transaction.getDocument(docRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard let oldValue = document.data()?["QTY"] as? NSNumber else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Unable to retrieve qty from snapshot \(document)"
                    ]
                )
                errorPointer?.pointee = error
                return nil
            }
            
            transaction.updateData(["QTY": oldValue.floatValue + qty], forDocument: docRef)
            return nil
            
        }) { (object, err) in
            if let err = err {
                self.displayAlert(title: "Something went wrong", message: "No changes made.\nPlease try again")
                print("ERROR: \(err)")
            } else {
                print("Transaction completed succesfully!")
                self.displayAlert(title: "Success!", message: "\(qty) \(unit)s of \(itemName) succesfully received in \(location)", handler: { (action) in
                    self.resetCells()
                    })
            }
            self.enableUI()
        }
    }
}

//================================================================================
// MARK: - Extensions
//================================================================================

extension ReceiveStockViewController: UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemPickerCell") as! ItemPickerTableViewCell
            cell.owner = self
            cell.headerLabel.text = "Item"
            return cell
        }
        else if (indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "locationPickerCell") as! LocationPickerTableViewCell
            cell.owner = self
            cell.headerLabel.text = "Location"
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "qtySelectionCell") as! SelectQtyTableViewCell
            return cell
        }
    }
}
