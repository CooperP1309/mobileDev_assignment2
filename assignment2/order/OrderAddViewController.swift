//
//  OrderAddViewController.swift
//  assignment2
//
//  Created by Cooper Peek on 10/10/2025.
//

import UIKit

class OrderAddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    // declare order DAO for db operations
    var dao = OrderDAO()
    
    // declaring of UI objects
    //  - buttons
    @IBOutlet weak var btnReturn: UIButton!
    @IBOutlet weak var btnAddDish: UIButton!
    
    //  - editTexts
    @IBOutlet weak var editOrderID: UITextField!
    @IBOutlet weak var editDishes: UITextField!
    @IBOutlet weak var editPrice: UITextField!
    
    //  - misc
    @IBOutlet weak var stepTableNo: UIStepper!
    @IBOutlet weak var textTableNum: UILabel!
    @IBOutlet weak var segDiningOpt: UISegmentedControl!
    @IBOutlet weak var textResponse: UILabel!
    
    //  - tableView related
    @IBOutlet weak var tableDishes: UITableView!
    
    // tableView init functions
    var dishes: [String] = ["Chips", "Burger", "Ribs"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // setting text from units array via indexing
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell0",
        for: indexPath)
        
        // setting row params
        cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel!.text = dishes[indexPath.row]

        return cell;
    }
    
    
    // ---- INITIALIZE VIEW FUNCTION ----
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize stepper attributes
        stepTableNo.wraps = true
        stepTableNo.autorepeat = true
        stepTableNo.maximumValue = 12
     }
    
    // action functions
    @IBAction func pressReturn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func pressAdd(_ sender: Any) {
        addOrder()
    }
    
    @IBAction func stepperChange(_ sender: Any) {
        let step = Int(stepTableNo.value)
        textTableNum.text = String(step)
    }
    
    
    @IBAction func pressSegDine(_ sender: Any) {
        if getDiningOpt() == "Take Away" {
            stepTableNo.alpha = 0.30
            textTableNum.alpha = 0.0
        }
        else {
            stepTableNo.alpha = 1.0
            textTableNum.alpha = 1.0
        }
    }
    
    
    func addOrder() {
        
        print("Adding order")
        
        // table number -> eat in logic
        var tableNum: String
        if getDiningOpt() == "Eat In" {
            tableNum = textTableNum.text!
        }
        else {
            tableNum = "0"
        }
        
        // collet form data into a passable struct (i.e. string only)
        let order = OrderForm(
            orderID: editOrderID.text!,
            tableNum: tableNum,
            diningOpt: getDiningOpt(),
            dishes: editDishes.text!,
            price: editPrice.text!)
        
        // push struct into DAO class for validation and db handling
        let results = dao.addOrderForm(orderForm: order)
        
        // notify user of success/failure

        textResponse.text = results
    }

    func getDiningOpt() -> String {
        return segDiningOpt.titleForSegment(at: segDiningOpt.selectedSegmentIndex)!
    }

}
