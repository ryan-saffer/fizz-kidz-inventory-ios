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
    
    @IBOutlet weak var itemPickerView: UIPickerView!
    @IBOutlet weak var fromPickerView: UIPickerView!
    @IBOutlet weak var toPickerView: UIPickerView!
    @IBOutlet weak var amountTextField: UITextField! {
        didSet { amountTextField?.addDoneToolbar() }
    }
    @IBOutlet weak var moveItemsButton: UIButton!
    
    var ingredients: [String] = [String]()
    var locations: [String] = [String]()
    
    // spinner
    var spinner: UIView? = nil
    
    //================================================================================
    // Methods
    //================================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ingredients = ["BICARB", "CIT_ACID", "PLATES"]
        self.locations = ["Warehouse","Malvern","Balwyn"]
    }

    @IBAction func moveButtonPressed(_ sender: Any) {
        
        let firestore: Firestore = Firestore.firestore()
        let item = self.ingredients[itemPickerView.selectedRow(inComponent: 0)]
        let amount = Float(self.amountTextField.text!) ?? 0
        let from = self.locations[fromPickerView.selectedRow(inComponent: 0)].uppercased()
        let to = self.locations[toPickerView.selectedRow(inComponent: 0)].uppercased()
        
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
                    self.displayAlert(title: "Something went wrong", message: "No changes made to the inventory, please try again")
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
        self.amountTextField.isEnabled = false
    }
    
    func enableUI() {
        UIViewController.removeSpinner(spinner: self.spinner!)
        self.moveItemsButton.isEnabled = true
        self.amountTextField.isEnabled = true
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

// MARK: UIPickerViewDelegate Methods
extension MoveStockViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1) {
            return self.ingredients[row]
        } else {
            return self.locations[row]
        }
    }
}

// MARK: UIPickerViewDataSource Methods
extension MoveStockViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1) {
            return self.ingredients.count
        }
        else {
            return self.locations.count
        }
        
    }
}
