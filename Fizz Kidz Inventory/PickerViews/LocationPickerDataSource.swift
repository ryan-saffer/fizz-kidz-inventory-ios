//
//  LocationPickerDataSource.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 12/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit

class LocationPickerDataSource: PickerViewDataSource {

    //================================================================================
    // MARK: - Methods
    //================================================================================
    override init() {
        super.init()
        
        // populate data
        self.data = []
        for location in Locations.names {
            self.data.append(location)
        }
    }
}
