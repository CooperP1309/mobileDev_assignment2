//
//  OrderListViewController.swift
//  assignment2
//
//  Created by Cooper Peek on 10/10/2025.
//

import UIKit
import CoreData

class OrderListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // global vars/objecst
    var dao = OrderDAO()
    var progDAO = OrderProgDAO()
    var selectedRows: [IndexPath] = []
    var targetOrder = OrderForm()
    var completedOrders: Set<String> = []
    
    // declaring of UI objects
    //  - text
    @IBOutlet weak var textResponse: UILabel!
    
    //  - buttons
    @IBOutlet weak var btnEditOrder: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnMarkDone: UIButton!
    
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
        //cell.detailTextLabel!.text = "Done"
        if completedOrders.contains(orders[indexPath.row]) {
            cell.detailTextLabel!.text = "Done"
        }
        else {
            cell.detailTextLabel!.text = ""
        }
        
        return cell
    }
    
    // handler for when a cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleSelectedRows()
        getOrderProgress(selectedIndex: indexPath)
    }
    
    // handler for when a cell is DEselected
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        handleSelectedRows()
    }
    
    func handleSelectedRows() {
    
        if tableOrders.indexPathsForSelectedRows == nil {
            btnEditOrder.isEnabled = false
            btnDelete.isEnabled = false
            btnMarkDone.isEnabled = false
            return
        }
   
        selectedRows = tableOrders.indexPathsForSelectedRows!
        
        if selectedRows.count > 1 {
            btnEditOrder.isEnabled = false
            return
        }
        
        btnDelete.isEnabled = true
        btnEditOrder.isEnabled = true
        btnMarkDone.isEnabled = true
    }
    
    func getOrderProgress(selectedIndex: IndexPath) {
        let order = orders[selectedIndex.row]
        
        // get ID of order
        let orderForm = dao.stringToOrderForm(string: order)
        
        // use this ID to retrieve the process time from prog dao
        let result = progDAO.getProcessTimeFromID(orderID: Int(orderForm.orderID)!)
        
        //print("\nOrderList:\n   Order: \(orderForm.orderID) \(result)")
        textResponse.text = "Order \(orderForm.orderID): \(result)"
    }
    
    // ---- VIEW INITIALIZE FUNCTION ----
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // by default, nothing is selected...
        btnEditOrder.isEnabled = false
        btnDelete.isEnabled = false
        
        // allow cells to fit many lines
        tableOrders.rowHeight = UITableView.automaticDimension
        tableOrders.estimatedRowHeight = 88
        tableOrders.allowsMultipleSelection = true
        
        // on startup, load the dishes db via retrieve()
        orders = dao.retrieveAllOrders()
        orders.forEach{ order in
            
            // ensure the push of newly completed orders
            if progDAO.isOrderDone(orderStr: order) {
                completedOrders.insert(order)
            }
        }
    }
    
    // ---- RELOAD FUNCTION ----
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // by default, nothing is selected...
        btnEditOrder.isEnabled = false
        btnDelete.isEnabled = false
        
        // allow cells to fit many lines
        tableOrders.rowHeight = UITableView.automaticDimension
        tableOrders.estimatedRowHeight = 88
        tableOrders.allowsMultipleSelection = true
        
        // on startup, load the dishes db via retrieve()
        orders = dao.retrieveAllOrders()
        orders.forEach{ order in
            
            // ensure the push of newly completed orders
            if progDAO.isOrderDone(orderStr: order) {
                completedOrders.insert(order)
            }
        }
        tableOrders.reloadData()
    }
    
    // --- Action Functions ----
    
    @IBAction func pressEditOrder(_ sender: Any) {
    }

    @IBAction func pressDelete(_ sender: Any) {
        
        // get each selected orders
        let selectedOrders = selectedRows.map { orders[$0.row] }
        
        // delete them orders
        dao.deleteManyFromStrings(orders: selectedOrders)
        
        // refresh the data
        orders = dao.retrieveAllOrders()
        orders.forEach{ order in
            
            // ensure the push of newly completed orders
            if progDAO.isOrderDone(orderStr: order) {
                completedOrders.insert(order)
            }
        }
        tableOrders.reloadData()
        btnDelete.isEnabled = false
    }
    
    @IBAction func pressMarkDone(_ sender: Any) {
        markOrderAsDone()
        
        // refresh the data
        orders = dao.retrieveAllOrders()
        orders.forEach{ order in
            
            // ensure the push of newly completed orders
            if progDAO.isOrderDone(orderStr: order) {
                completedOrders.insert(order)
            }
        }
        tableOrders.reloadData()
        
        // update the progress
        getOrderProgress(selectedIndex: selectedRows.last!)
    }
    
    func markOrderAsDone() {
        
        // for each row
        for currentOrder in selectedRows {
            
            // extract the given row ID
            let orderStr = orders[currentOrder.row]
            let order = dao.stringToOrderForm(string: orderStr)
            let id = Int(order.orderID)
            
            // update the OrderProg record
            let result = progDAO.markAsDone(orderID: id!)
            print("\nProgDAO:\n   \(result)")
        }
    }
    
    // prepare function packs data struct for use in next view segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier != "OrderUpdateForm" {
            return
        }
        
        // Unwrap real destination (handles nav-controller wrapping)
        let destination: OrderUpdateViewController
        if let nav = segue.destination as? UINavigationController,
           let top = nav.topViewController as? OrderUpdateViewController {
            destination = top
        } else if let vc = segue.destination as? OrderUpdateViewController {
            destination = vc
        } else {
            assertionFailure("Unexpected destination: \(segue.destination)")
            return
        }
        
        // get the selected order string...
        let selectedOrder = selectedRows.map { orders[$0.row] }
        
        // process it into a valid form object (i.e. struct of strings)
        destination.order = dao.stringToOrderForm(string: selectedOrder[0])
    
        // testing it was populated
        //print("Dest Order Dishes: " + destination.order.dishes)
    }
}
