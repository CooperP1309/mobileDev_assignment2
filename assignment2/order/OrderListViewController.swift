//
//  OrderListViewController.swift
//  assignment2
//
//  Created by Cooper Peek on 10/10/2025.
//

import UIKit

class OrderListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // global vars/objecst
    var dao = OrderDAO()
    var selectedRows: [IndexPath] = []
    
    // declaring of UI objects
    //  - text
    
    @IBOutlet weak var textResponse: UILabel!
    
    //  - buttons
    @IBOutlet weak var btnEditOrder: UIButton!
    
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
    
    // handler for when a cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleSelectedRows()
    }
    
    // handler for when a cell is DEselected
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        handleSelectedRows()
    }
    
    func handleSelectedRows() {
        if tableOrders.indexPathsForSelectedRows == nil {
            btnEditOrder.isEnabled = false
            return
        }
        btnEditOrder.isEnabled = true
        selectedRows = tableOrders.indexPathsForSelectedRows!
    }
    
    // ---- VIEW INITIALIZE FUNCTION ----
    override func viewDidLoad() {
        super.viewDidLoad()
            
        // by default, nothing is selected...
        btnEditOrder.isEnabled = false
        
        // allow cells to fit many lines
        tableOrders.rowHeight = UITableView.automaticDimension
        tableOrders.estimatedRowHeight = 88
        tableOrders.allowsMultipleSelection = true
        
        // on startup, load the dishes db via retrieve()
        orders = dao.retrieveAllOrders()
        orders.forEach{ order in
            print(order)
        }
    }
    
    // ---- RELOAD FUNCTION ----
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // by default, nothing is selected...
        btnEditOrder.isEnabled = false
        
        // allow cells to fit many lines
        tableOrders.rowHeight = UITableView.automaticDimension
        tableOrders.estimatedRowHeight = 88
        tableOrders.allowsMultipleSelection = true
        
        // on startup, load the dishes db via retrieve()
        orders = dao.retrieveAllOrders()
        orders.forEach{ order in
            print(order)
        }
        tableOrders.reloadData()
    }
    
    // --- Action Functions ----
    
    @IBAction func pressEditOrder(_ sender: Any) {
        
        // only proceed to edit form if one and exactly one form is selected
        if selectedRows.count != 1 {
            textResponse.text = "Please select only one row for editing..."
        }
        else {
            // get the selected order string...
            let selectedOrder = selectedRows.map { orders[$0.row] }
            
            // process it into a valid form object (i.e. struct of strings)
            var orderForm = dao.stringToOrderForm(string: selectedOrder[0])
            
            // prepare it for the editOrderForm
            
        }

    }
    
}
