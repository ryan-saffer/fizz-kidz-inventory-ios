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
        let locations = Locations()
        self.data = []
        for location in locations.names {
            self.data.append(location)
        }
    }
}
