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
    var orderDAO = OrderDAO()
    var dishes: [String] = []
    var selectedDishes: Set<String> = []
    let docsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    // ---- declare UI objects ----
    //  - text
    @IBOutlet weak var textIDNum: UILabel!
    @IBOutlet weak var textResponse: UILabel!
    @IBOutlet weak var textTableNum: UILabel!
    
    //  - edit text
    @IBOutlet weak var editPrice: UITextField!

    //  - buttons
    @IBOutlet weak var btnUpdateOrder: UIButton!
    @IBOutlet weak var btnDeleteOrder: UIButton!
    
    //  - misc
    @IBOutlet weak var stepTableNum: UIStepper!
    @IBOutlet weak var segDiningOpt: UISegmentedControl!
    
    //  - tableView related UI
    @IBOutlet weak var tableDish: UITableView!
    
    // ---- table view init functions ----
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes.count
    }
    
    // function initializes each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
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
        }

        return cell;
        */
        
        // setting text from units array via indexing
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell0",
        for: indexPath)
        
        // setting row params and loading dish data
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        // set as the record without its image name
        cell.textLabel!.text = dishDAO.stripImageFromDishStr(dishStr: dishes[indexPath.row])
        
        // disable interactivity for header cells and configure header text properties
        if dishes[indexPath.row] == "Drink" || dishes[indexPath.row] == "Entree" || dishes[indexPath.row] == "Main" {
            cell.isUserInteractionEnabled = false
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            
            // ensure the image slot is cleared
            cell.imageView?.image = nil
            cell.accessoryView = nil
        }
        else {
            cell.isUserInteractionEnabled = true
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
                
            // only try to load an image if it's a valid dish
            // loading of image
            cell.imageView?.image = loadImage(dish: dishes[indexPath.row])
            
            // setting attributes of image view
            cell.imageView?.contentMode = .scaleAspectFill
            cell.imageView?.layer.cornerRadius = 6
            cell.imageView?.clipsToBounds = true
            cell.imageView?.frame.size = CGSize(width: 60, height: 60)
        }
        
        return cell;
    }
    
    // handler for when a cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updatePriceFromSelectedDishes()
    }
    
    // handler for when a cell is DEselected
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        updatePriceFromSelectedDishes()
    }
    
    func updatePriceFromSelectedDishes() {
        // if there are selected rows
        if let selectedRows = tableDish.indexPathsForSelectedRows {
            
            // compile each selected row into array
            let selectedDishes = selectedRows.map { dishes[$0.row] }
            print("selected dishes:\n\(selectedDishes)")
            
            // adjust the price to account for new selection of dishes
            let price = dishDAO.getPriceFromSelected(dishArray: selectedDishes)
            editPrice.text = String(price)
        }
        else {
            print("no dishes selected")
            editPrice.text = "0.0"
        }
    }
    
    // ---- VIEW INITIALIZATION FUNCTION ----
    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize tableView properties
        selectedDishes = Set(dishDAO.getSelectedDishArray(dishNames: order.dishes))
        tableDish.allowsMultipleSelection = true
        
        print("\nUpdateDish:\n  Selected dishes list:\n")
        for dish in selectedDishes {
            print(dish)
        }
        
        // initialize stepper attributes
        stepTableNum.wraps = true
        stepTableNum.autorepeat = true
        stepTableNum.maximumValue = 12
        
        // on startup, load the dishes db via retrieve()
        dishes = dishDAO.retrieveAllDishes()
        print("\nUpdateOrder:\nRetrieved Dishes from db:")
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
    
    // Function waits till all UI objects are loaded
    // we use this func to select our desired rows in the table
    // because we must wait till after the data is initialized for comparison
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for (index, dish) in dishes.enumerated() {
            if selectedDishes.contains(dish) {
                print("marking as selected: \"" + dish + "\"")
                let indexPath = IndexPath(row: index, section: 0)
                tableDish.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                tableDish.delegate?.tableView?(tableDish, didSelectRowAt: indexPath)
            }
            else {
                print("\nUpdateOrder:\n not in selected dishes: \(dish)")
            }
        }
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
    
    @IBAction func pressUpdate(_ sender: Any) {
        updateOrder()
    }
    
    @IBAction func pressDelete(_ sender: Any) {
        let result = orderDAO.deleteOrder(id: order.orderID)
        textResponse.text = result
        
        // return afterwards
        dismiss(animated: true)
    }
    
    // ---- action triggered functions
    
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
    
    func updateOrder() {
        
        // table number -> eat in logic
        var tableNum: String
        if getDiningOpt() == "Eat In" {
            tableNum = textTableNum.text!
        }
        else {
            tableNum = "0"
        }
        
        // compiling of selected dish names for order struct
        var dishNames = ""
        if let selectedRows = tableDish.indexPathsForSelectedRows {
            let selectedDishes = selectedRows.map { dishes[$0.row] }
            dishNames = dishDAO.getSelectedDishNames(selectedDishes: selectedDishes)
        }
        
        print("\nRetrieved dish names:\n" + dishNames)
        
        // collet form data into a passable struct (i.e. string only struct)
        let order = OrderForm(
            orderID: textIDNum.text!,
            tableNum: tableNum,
            diningOpt: getDiningOpt(),
            dishes: dishNames,
            price: editPrice.text!)
        
        // push struct into DAO class for validation and db handling
        let results = orderDAO.updateOrderForm(orderForm: order)
        
        textResponse.text = results
        
        // notify user of success/failure
        if results == "Update Successful" {
            dismiss(animated: true)
        }
    }
    
    func loadImage(dish: String) -> UIImage? {
        
        // we get the image name from record (via DAO)
        let fileName = dishDAO.getImageFromDishStr(dishStr: dish)
        
        // check for empty imageName
        if fileName.isEmpty {
            return nil
        }

        // get the image from storage using image name
        let filePath = docsPath.appendingPathComponent(fileName)
        let image = UIImage(contentsOfFile: filePath.path)
        
        // return the image at a thumbnail size
        return imageThumbnail(from: image!, size: CGSize(width: 60, height: 60))
    }
    
    func imageThumbnail(from image: UIImage, size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
