//
//  OrderListViewController.swift
//  assignment2
//
//  Created by Cooper Peek on 10/10/2025.
//

import UIKit

class OrderListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // declare object of order DAO
    var dao = OrderDAO()
    
    // declaring of UI objects
    //  - tableView related
    @IBOutlet weak var tableOrders: UITableView!
    
    // ---- table view init functions ----
    var orders: [String] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // setting text from units array via indexing
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell0", for: indexPath)
        
        // setting row params
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel!.text = orders[indexPath.row]
        
        return cell
    }
    
    // ---- VIEW INITIALIZE FUNCTION
    override func viewDidLoad() {
        super.viewDidLoad()
            
        // allow cells to fit many lines
        tableOrders.rowHeight = UITableView.automaticDimension
        tableOrders.estimatedRowHeight = 88
        
        // on startup, load the dishes db via retrieve()
        orders = dao.retrieveAllOrders()
        orders.forEach{ order in
            print(order)
        }
    }
}
