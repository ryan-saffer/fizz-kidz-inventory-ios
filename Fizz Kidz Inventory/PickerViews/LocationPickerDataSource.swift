//
//  LocationPickerDataSource.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 12/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit

class LocationPickerDataSource: PickerViewDataSource {

    override init() {
        super.init()
        self.data = ["Warehouse","Malvern","Balwyn"]
    }
}
