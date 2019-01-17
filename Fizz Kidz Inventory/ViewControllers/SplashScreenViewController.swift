//
//  SplashScreenViewController.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 16/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit
import FirebaseFirestore

/// Pre-load item information from Firestore and store as global variables
class SplashScreenViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // create loading indicator and display in centre
        self.activityIndicator.startAnimating()
        self.fetchFirestoreData()
    }
    
    /// fetches item codes and display names from firestore and stores into global structs
    func fetchFirestoreData() {
        
        let firestore: Firestore = Firestore.firestore()
        let location = "WAREHOUSE" // all location items match, can use any
        
        firestore.collection(location).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("ERROR: \(error)")
            } else {
                for item in querySnapshot!.documents {
                    Items.item_names[item.documentID] = item.data()["DISP_NAME"] as? String
                    Items.item_units[item.documentID] = item.data()["UNIT"] as? String
                }
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "segue", sender: nil)
            }
        }
    }
}
