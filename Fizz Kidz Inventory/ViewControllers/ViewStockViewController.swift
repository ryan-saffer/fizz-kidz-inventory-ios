//
//  ViewStockViewController.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 10/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ViewStockViewController: UIViewController, LogOutProtocol {

    //================================================================================
    // MARK: - Properties
    //================================================================================
    
    // IBOutlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logOutIcon: UIImageView!

    // variables
    var firestore: Firestore!
    var ingredientData: [[String: Any]] = [[String: Any]]()
    var foodData:       [[String: Any]] = [[String: Any]]()
    var generalData:    [[String: Any]] = [[String: Any]]()
    var packagingData:  [[String: Any]] = [[String: Any]]()
    var otherData:      [[String: Any]] = [[String: Any]]()
    
    //================================================================================
    // MARK: - Methods
    //================================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add pull-to-refresh to tableview
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        
        // set segmentControl target when changed
        self.segmentedControl.addTarget(self, action: #selector(self.segmentChanged), for: .valueChanged)
        
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.rowHeight = UITableView.automaticDimension
        
        // log out icon
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(logOutTapped))
        self.logOutIcon.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.refresh()
    }
    
    /// Log out button target - logs out of Google Sign In and returns to login page
    @objc func logOutTapped(recognizer: UIGestureRecognizer) {
        self.logOut()
    }
    
    /// Pulls the latest data from Firestore
    func reloadData() {
        
        firestore = Firestore.firestore()
        
        let location: String = self.segmentedControl.titleForSegment(at: self.segmentedControl.selectedSegmentIndex)!.uppercased()
        
        firestore.collection(location).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("ERROR: \(err)")
            } else {
                
                self.ingredientData.removeAll()
                self.foodData.removeAll()
                self.generalData.removeAll()
                self.packagingData.removeAll()
                self.otherData.removeAll()
                
                for ingredient in querySnapshot!.documents {
                    
                    var data: [String: Any] = [:]
                    data["ITEM_ID"] = ingredient.documentID
                    data["QTY"] = ingredient.data()["QTY"]
                    data["UNIT"] = ingredient.data()["UNIT"]
                    data["DISP_NAME"] = ingredient.data()["DISP_NAME"]
                    data["HIGH"] = ingredient.data()["HIGH"]
                    data["LOW"] = ingredient.data()["LOW"]
                    
                    let category = ingredient.data()["CATEGORY"] as! String
                    switch category {
                    case "FOOD":
                        self.foodData.append(data)
                    case "INGREDIENT":
                        self.ingredientData.append(data)
                    case "GENERAL":
                        self.generalData.append(data)
                    case "PACKAGING":
                        self.packagingData.append(data)
                    default: // "OTHER"
                        self.otherData.append(data)
                    }
                }
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
    /// Displays pull-to-refresh icon before reloading from Firestore
    func refresh() {
        self.tableView.refreshControl?.beginRefreshing()
        self.tableView.setContentOffset(
            CGPoint(
                x: 0,
                y: self.tableView.contentOffset.y-(self.tableView.refreshControl?.frame.size.height)!
            ),
            animated: true
        )
        self.tableView.reloadData() // do this to fix strange refresh control behaviour
        self.reloadData()
    }
    
    /// Called when pull-to-refresh gesture made
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        //self.reloadData()
        self.refresh()
    }
    
    /// Called when segment (location) changed
    @objc func segmentChanged(segment: UISegmentedControl) {
        self.refresh()
    }
}

//================================================================================
// MARK: - Extensions
//================================================================================

extension ViewStockViewController: UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Food"
        case 1:
            return "General"
        case 2:
            return "Packaging"
        case 3:
            return "Ingredients"
        default:
            return "Other"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.foodData.count
        case 1:
            return self.generalData.count
        case 2:
            return self.packagingData.count
        case 3:
            return self.ingredientData.count
        default:
            return self.otherData.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! StockTableViewCell
        var data: [String: Any]!
        switch indexPath.section {
        case 0:
            data = self.foodData[indexPath.row]
        case 1:
            data = self.generalData[indexPath.row]
        case 2:
            data = self.packagingData[indexPath.row]
        case 3:
            data = self.ingredientData[indexPath.row]
        default:
            data = self.otherData[indexPath.row]
        }
        cell.setData(data)
        return cell
    }
}

extension ViewStockViewController: UITableViewDelegate {
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
