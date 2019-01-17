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
    var locationData: [[String: Any]] = [[String: Any]]()
    
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
                    var data: [String: Any] = [:]
                    data["ITEM_ID"] = ingredient.documentID
                    data["QTY"] = ingredient.data()["QTY"]
                    data["UNIT"] = ingredient.data()["UNIT"]
                    data["DISP_NAME"] = ingredient.data()["DISP_NAME"]
                    data["HIGH"] = ingredient.data()["HIGH"]
                    data["LOW"] = ingredient.data()["LOW"]
                    self.locationData.append(data)
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
        cell.setData(self.locationData[indexPath.row])
        return cell
    }
}

extension ViewStockViewController: UITableViewDelegate {
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
