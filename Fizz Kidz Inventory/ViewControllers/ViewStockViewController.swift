//
//  ViewStockViewController.swift
//  Fizz Kidz Inventory
//
//  Created by Ryan Saffer on 10/1/19.
//  Copyright © 2019 Fizz Kidz. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ViewStockViewController: UIViewController, UITableViewDataSource {

    //================================================================================
    // Properties
    //================================================================================
    
    // IBOutlets
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    // variables
    var firestore: Firestore! = nil
    var locationData: [[String]] = [[String]]()
    
    // spinner
    var spinner: UIView? = nil
    
    //================================================================================
    // Methods
    //================================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        
        self.segmentedControl.addTarget(self, action: #selector(self.segmentChanged), for: .valueChanged)
        
        self.refresh()
    }
    
    func reloadData() {
        
        // get data from firestore
        firestore = Firestore.firestore()
        
        let location: String = self.segmentedControl.titleForSegment(at: self.segmentedControl.selectedSegmentIndex)!.uppercased()
        
        firestore.collection(location).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("ERROR: \(err)")
            } else {
                self.locationData.removeAll()
                let items = Items()
                for ingredient in querySnapshot!.documents {
                    let value = ingredient.data()["QTY"]!
                    let unit = ingredient.data()["UNIT"]!
                    let itemID = ingredient.documentID
                    let itemName = (items.itemIds as NSDictionary).allKeys(for: itemID) as! [String]
                    self.locationData.append([
                                        itemName[0],
                                        String(describing: value),
                                        String(describing: unit)
                                        ])
                }
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! StockTableViewCell
        cell.nameLabel.text = self.locationData[indexPath.row][0]
        cell.qtyLabel.text = self.locationData[indexPath.row][1]
        cell.unitLabel.text = self.locationData[indexPath.row][2]
        return cell
    }
    
    func refresh() {
        self.tableView.refreshControl?.beginRefreshing()
        self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentOffset.y-(self.tableView.refreshControl?.frame.size.height)!), animated: true)
        self.reloadData()
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        self.reloadData()
    }
    
    @objc func segmentChanged(segment: UISegmentedControl) {
        self.refresh()
    }
}
