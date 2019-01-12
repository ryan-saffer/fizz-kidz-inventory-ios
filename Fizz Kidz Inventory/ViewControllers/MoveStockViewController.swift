//
//  ViewController.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 8/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit
import FirebaseFirestore

class MoveStockViewController: UIViewController {
    
    //================================================================================
    // Properties
    //================================================================================
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var moveItemsButton: UIButton!
    
    // spinner
    var spinner: UIView? = nil
    
    //================================================================================
    // Methods
    //================================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func moveButtonPressed(_ sender: Any) {
        
        let firestore: Firestore = Firestore.firestore()
        
        let itemCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! IngredientPickerTableViewCell
        let fromCell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! LocationPickerTableViewCell
        let toCell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! LocationPickerTableViewCell
        let qtyCell = self.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! SelectQtyTableViewCell
        
        guard let item = itemCell.selectedItem?.uppercased() else {
            self.displayAlert(title: "Select item", message: "Tap 'Select' to select the item being received")
            return
        }
        guard let from = fromCell.selectedItem?.uppercased() else {
            self.displayAlert(title: "Select 'From' location", message: "Tap 'Select' to select the location the item is being moved from")
            return
        }
        guard let to = toCell.selectedItem?.uppercased() else {
            self.displayAlert(title: "Select 'To' location", message: "Tap 'Select' to select the location the item is being moved to")
            return
        }
        let amount = Float(qtyCell.qtyTextField.text!) ?? 0
        
        self.disableUI()
        
        if (amount <= 0) {
            displayAlert(title: "Quantity invalid", message: "Change the quantity value and try again")
            self.enableUI()
            return
        }
        
        if (from == to) {
            displayAlert(title: "Locations must be different", message: "Make sure the stock is being moved between two separate locations")
            self.enableUI()
            return
        }
        
        let fromRef = firestore.document("\(from)/\(item)")
        let toRef = firestore.document("\(to)/\(item)")
        
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
            if (amount > oldFromValue.floatValue) {
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
            
            transaction.updateData(["QTY": oldFromValue.floatValue - amount], forDocument: fromRef)
            transaction.updateData(["QTY": oldToValue.floatValue + amount], forDocument: toRef)
            return nil
            
        }) { (object, error) in
            if let error = error {
                // react to errors accordingly
                if (error.localizedDescription == "Not enough stock to perform move") {
                    self.displayAlert(title: "Not enough stock", message: "Not enough stock to perform move")
                } else {
                    self.displayAlert(title: "Something went wrong", message: "No changes made.\n Please try again")
                }
                print("Transaction failed: \(error)")
            } else {
                self.displayAlert(title: "Done!", message: "\(amount) \(item)s moved from \(from) to \(to)")
                print("Transaction succesfully commited!")
            }
            self.enableUI()
        }
    }
    
    func disableUI() {
        self.spinner = UIViewController.displaySpinner(onView: self.view)
        self.moveItemsButton.isEnabled = false
    }
    
    func enableUI() {
        UIViewController.removeSpinner(spinner: self.spinner!)
        self.moveItemsButton.isEnabled = true
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
extension MoveStockViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemPickerCell") as! IngredientPickerTableViewCell
            cell.owner = self
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "qtyPickerCell") as! SelectQtyTableViewCell
            return cell
        }
    }
}
