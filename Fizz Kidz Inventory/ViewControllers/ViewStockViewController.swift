//
//  ViewStockViewController.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 10/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ViewStockViewController: UIViewController {

    //================================================================================
    // MARK: - Properties
    //================================================================================
    
    // IBOutlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    // variables
    var firestore: Firestore!
    var locationData: [[String]] = [[String]]()
    
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
        
        self.refresh()
    }
    
    /// Pulls the latest data from Firestore
    func reloadData() {
        
        firestore = Firestore.firestore()
        
        let location: String = self.segmentedControl.titleForSegment(at: self.segmentedControl.selectedSegmentIndex)!.uppercased()
        
        firestore.collection(location).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("ERROR: \(err)")
            } else {
                self.locationData.removeAll()
                for ingredient in querySnapshot!.documents {
                    let qty = ingredient.data()["QTY"]!
                    let unit = ingredient.data()["UNIT"]!
                    let itemID = ingredient.documentID
                    let itemName = (Items.itemIds as NSDictionary).allKeys(for: itemID) as! [String]
                    self.locationData.append([
                                        itemID,
                                        itemName[0],
                                        String(describing: qty),
                                        String(describing: unit)
                                        ])
                }
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
    /// Displays pull-to-refresh icon before reloading from Firestore
    func refresh() {
        self.tableView.refreshControl?.beginRefreshing()
        self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentOffset.y-(self.tableView.refreshControl?.frame.size.height)!), animated: true)
        self.reloadData()
    }
    
    /// Called when pull-to-refresh gesture made
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        self.reloadData()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locationData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! StockTableViewCell
        cell.setData(itemID:    self.locationData[indexPath.row][0],
                     itemName:  self.locationData[indexPath.row][1],
                     qty:       self.locationData[indexPath.row][2],
                     unit:      self.locationData[indexPath.row][3])
        return cell
    }
}

extension ViewStockViewController: UITableViewDelegate {
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
