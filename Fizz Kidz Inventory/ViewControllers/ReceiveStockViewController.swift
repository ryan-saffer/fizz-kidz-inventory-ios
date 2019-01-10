//
//  ReveiveStockViewController.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 10/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ReceiveStockViewController: UIViewController {
    
    // IBOutlets
    @IBOutlet weak var itemPickerView: UIPickerView!
    @IBOutlet weak var qtyTextField: UITextField! {
        didSet { qtyTextField?.addDoneToolbar() }
    }
    @IBOutlet weak var receiveButton: UIButton!
    
    // variables
    var ingredients: [String] = [String]()
    
    // spinner
    var spinner: UIView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.ingredients = ["BICARB", "CIT_ACID", "PLATES"]
    }
    
    @IBAction func reveiveStockButtonPressed(_ sender: Any) {
        
        let firestore: Firestore = Firestore.firestore()
        let item = self.ingredients[self.itemPickerView.selectedRow(inComponent: 0)]
        let qty = Float(self.qtyTextField.text!) ?? 0
        
        self.disableUI()
        
        let docRef = firestore.document("WAREHOUSE/\(item)")
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
                print("ERROR: \(err)")
            } else {
                print("Transaction completed succesfully!")
            }
            self.enableUI()
        }
    }
    
    func disableUI() {
        self.spinner = UIViewController.displaySpinner(onView: self.view)
        self.qtyTextField.isEnabled = false
        self.receiveButton.isEnabled = false
    }
    
    func enableUI() {
        UIViewController.removeSpinner(spinner: self.spinner!)
        self.qtyTextField.isEnabled = true
        self.receiveButton.isEnabled = true
    }
}

extension ReceiveStockViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.ingredients[row]
    }
}

extension ReceiveStockViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.ingredients.count
    }
    
    
}
