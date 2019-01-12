//
//  ReveiveStockViewController.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 10/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ReceiveStockViewController: ManageStockViewController, UITextFieldDelegate {
    
    //================================================================================
    // Properties
    //================================================================================
    
    // IBOutlets
    @IBOutlet weak var receiveButton: UIButton!
    
    // spinner
    var spinner: UIView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //================================================================================
    // Methods
    //================================================================================
    
    @IBAction func receiveStockButtonPressed(_ sender: Any) {
        
        let items = Items()
        
        let itemCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! IngredientPickerTableViewCell
        let locationCell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! LocationPickerTableViewCell
        let qtyCell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! SelectQtyTableViewCell
        
        guard let itemName = itemCell.selectedItem else {
            self.displayAlert(title: "Select item", message: "Tap 'Select' to select the item being received")
            return
        }
        let itemID = String(describing: items.itemIds[itemName]!)
        
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
        
        let confirmationAlert = UIAlertController(title: "Confirm receival", message: "\(qty) \(unit)s of \(itemName) will be received in \(location)", preferredStyle: UIAlertController.Style.alert)
        confirmationAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
            self.reveiveStock(itemName: itemName, itemID: itemID, location: location, qty: qty, unit: unit)
        }))
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            return
        }))
        present(confirmationAlert, animated: true, completion: nil)
    }
    
    func reveiveStock(itemName: String, itemID: String, location: String, qty: Float, unit: String) {
        
        self.disableUI()
        
        let firestore: Firestore = Firestore.firestore()
        let docRef = firestore.document("\(location.uppercased())/\(itemID)")
        
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
                self.displayAlert(title: "Success!", message: "\(qty) \(unit)s of \(itemName) succesfully received in \(location)")
            }
            self.enableUI()
        }
    }
    
    func disableUI() {
        self.spinner = UIViewController.displaySpinner(onView: self.view)
        self.receiveButton.isEnabled = false
    }
    
    func enableUI() {
        UIViewController.removeSpinner(spinner: self.spinner!)
        self.receiveButton.isEnabled = true
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//================================================================================
// Extensions
//================================================================================

// MARK: UITableViewDataSource
extension ReceiveStockViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemPickerCell") as! IngredientPickerTableViewCell
            cell.owner = self
            return cell
        }
        else if (indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "locationPickerCell") as! LocationPickerTableViewCell
            cell.owner = self
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "qtyPickerCell") as! SelectQtyTableViewCell
            return cell
        }
    }
}
