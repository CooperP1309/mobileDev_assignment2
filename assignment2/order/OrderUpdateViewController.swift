//
//  OrderUpdateViewController.swift
//  assignment2
//
//  Created by Cooper Peek on 11/10/2025.
//

import UIKit

class OrderUpdateViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // declare global vars/objects
    var order = OrderForm()
    var dishDAO = DishDAO()
    var dishes: [String] = []
    var selectedDishes: Set<String> = []
    
    // ---- declare UI objects ----
    //  - text
    @IBOutlet weak var textIDNum: UILabel!
    @IBOutlet weak var textResponse: UILabel!
    @IBOutlet weak var textTableNum: UILabel!
    
    //  - edit text
    @IBOutlet weak var editPrice: UITextField!

    //  - buttons
    
    @IBOutlet weak var btnUpdateOrder: UIButton!
    //  - misc
    @IBOutlet weak var stepTableNum: UIStepper!
    @IBOutlet weak var segDiningOpt: UISegmentedControl!
    
    //  - tableView related UI
    @IBOutlet weak var tableDish: UITableView!
    
    // ---- table view init functions ----
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // setting text from units array via indexing
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell0", for: indexPath)
        
        // setting row params
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel!.text = dishes[indexPath.row]
        
        // disable interactivity for header cells and configure header text properties
        if dishes[indexPath.row] == "Drink" || dishes[indexPath.row] == "Entree" || dishes[indexPath.row] == "Main" {
            cell.isUserInteractionEnabled = false
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        }
        else {
            cell.isUserInteractionEnabled = true
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            
            // for each cell containing a selected dish
            if selectedDishes.contains(cell.textLabel!.text!) {
                print("Trying to select cell with record: " + dishes[indexPath.row])
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
            }
        }

        return cell;
    }
    
    // ---- VIEW INITIALIZATION FUNCTION ----
    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize tableView properties
        selectedDishes = Set(dishDAO.getSelectedDishArray(dishNames: order.dishes))
        tableDish.allowsMultipleSelection = true
        
        // initialize stepper attributes
        stepTableNum.wraps = true
        stepTableNum.autorepeat = true
        stepTableNum.maximumValue = 12
        
        // on startup, load the dishes db via retrieve()
        dishes = dishDAO.retrieveAllDishes()
        print("Retrieved Dishes from db:\n")
        dishes.forEach{ dish in
            print(dish)
        }
        print("\n")
        
        // ---- SETTING OF FORM FIELDS ----
        print("UNPACKED ORDER DISHES IN UPDATE VIEW : " + order.dishes)
        textIDNum.text = order.orderID
        
        if order.diningOpt == "Take Away" {
            stepTableNum.isEnabled = false
            textTableNum.alpha = 0.0
            textTableNum.text = "0"
        }
        else {
            textTableNum.text = order.tableNum
        }
        setSegment(order: order.diningOpt)
        editPrice.text = order.price
        

    }

    // ---- action functions ----
    
    @IBAction func pressReturn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func pressDiningOpt(_ sender: Any) {
        if getDiningOpt() == "Take Away" {
            stepTableNum.isEnabled = false
            textTableNum.alpha = 0.0
        }
        else {
            stepTableNum.isEnabled = true
            textTableNum.alpha = 1.0
        }
    }
    
    @IBAction func pressStepper(_ sender: Any) {
        let step = Int(stepTableNum.value)
        textTableNum.text = String(step)
    }
    
    
    func getDiningOpt() -> String {
        return segDiningOpt.titleForSegment(at: segDiningOpt.selectedSegmentIndex)!
    }
    
    func setSegment(order: String) {
        switch order {
        case "Eat In":
            segDiningOpt.selectedSegmentIndex = 0
            break
        
        case "Take Away":
            segDiningOpt.selectedSegmentIndex = 1
            break
            
        default:
            break
        }
    }
    
}
