//
//  NoCursorTextField.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 14/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit

class NoCursorTextField: UITextField {

    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect(x: 0, y: 0, width: 0, height: 0)
    }
}
