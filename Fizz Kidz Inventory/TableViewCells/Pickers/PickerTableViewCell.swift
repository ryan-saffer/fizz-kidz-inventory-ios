//
//  PickerTableViewCell.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 11/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit

/**
 Table cell used for selecting something using a picker view
 
 See https://stackoverflow.com/a/37517958/7870403
 */
class PickerTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    //================================================================================
    // MARK: - Properties
    //================================================================================
    
    // IBOutlets - set programatically inside init
    /// 'hidden' text field used to react to label being selected
    weak var textField: NoCursorTextField!
    weak var itemLabel: UILabel!
    weak var headerLabel: UILabel!
    
    // variables
    weak var owner: ManageStockViewController!
    var picker: UIPickerView!
    var pickerDataSource: PickerViewDataSource! {
        didSet {
            self.picker.dataSource = self.pickerDataSource
        }
    }
    var selectedItem: String? = nil
    
    //================================================================================
    // MARK: - Methods
    //================================================================================
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // load the xib to associate with
        let nib = Bundle.main.loadNibNamed("PickerTableViewCell", owner: nil, options: nil)
        if let view = nib?.first as? UIView{
            self.addSubview(view)
        }
        
        // link each view to parameter (since xib assigned programatically, no IBOutlets exist)
        if let headerLabel = self.viewWithTag(1) as? UILabel {
            self.headerLabel = headerLabel
        }
        if let textField = self.viewWithTag(2) as? NoCursorTextField {
            self.textField = textField
            self.textField.addTarget(self, action: #selector(self.itemSelected(_:)), for: .editingDidBegin)
        }
        if let itemLabel = self.viewWithTag(3) as? UILabel {
            self.itemLabel = itemLabel
        }
        
        self.picker = UIPickerView(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
        self.picker.delegate = self
        
        self.assignPickerDataSource()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     Create and assign the picker view data source
 
     Must be overriden by child classes
    */
    func assignPickerDataSource() {
        fatalError("Must Override")
    }
    
    /// Called when 'Done' button from picker view selected
    @objc func pickerItemSelected(_ sender: UIButton) {
        let selectedItem = self.pickerDataSource.data[self.picker.selectedRow(inComponent: 0)]
        self.itemLabel.text = selectedItem
        self.selectedItem = selectedItem
        
        self.textField.resignFirstResponder()
    }
    
    @objc func itemSelected(_ sender: UITextField) {
        // Create the picker view
        let tintColor: UIColor = UIColor(red: 101.0/255.0, green: 98.0/255.0, blue: 164.0/255.0, alpha: 1.0)
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: self.owner.view.frame.width, height: 240))
        self.picker.tintColor = tintColor
        self.picker.center.x = inputView.center.x
        inputView.addSubview(self.picker) // add picker to UIView
        
        let doneButton = UIButton(frame: CGRect(x: owner.view.frame.size.width - 3*(100/2), y: 0, width: 100, height: 50))
        doneButton.setTitle("Done", for: UIControl.State.normal)
        doneButton.setTitle("Done", for: UIControl.State.highlighted)
        doneButton.setTitleColor(tintColor, for: UIControl.State.normal)
        doneButton.setTitleColor(tintColor, for: UIControl.State.highlighted)
        inputView.addSubview(doneButton) // add Button to UIView
        doneButton.addTarget(self, action: #selector(pickerItemSelected(_:)), for: UIControl.Event.touchUpInside) // set button click event
        sender.inputView = inputView
    }
}

//================================================================================
// MARK: - Extensions
//================================================================================

extension PickerTableViewCell: UIPickerViewDelegate {
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerDataSource.data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.itemLabel.text = self.pickerDataSource.data[row]
        self.selectedItem = self.pickerDataSource.data[row]
    }
}
