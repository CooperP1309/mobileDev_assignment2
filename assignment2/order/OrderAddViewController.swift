//
//  OrderAddViewController.swift
//  assignment2
//
//  Created by Cooper Peek on 10/10/2025.
//

import UIKit

class OrderAddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // declare order DAO for db operations
    var daoOrder = OrderDAO()
    var daoDish = DishDAO()
    
    // declare a pointer to where images are saved
    let docsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    // ---- declaring of UI objects ----
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
    
    // ---- tableView init functions ----
    var dishes: [String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes.count
    }
    
    // initializing of tableview cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
         // OLD IMPLEMENTATION
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
        cell.textLabel!.text = daoDish.stripImageFromDishStr(dishStr: dishes[indexPath.row])
        
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
        if let selectedRows = tableDishes.indexPathsForSelectedRows {
            
            // compile each selected row into array
            let selectedDishes = selectedRows.map { dishes[$0.row] }
            print("selected dishes:\n\(selectedDishes)")
            
            // adjust the price to account for new selection of dishes
            let price = daoDish.getPriceFromSelected(dishArray: selectedDishes)
            editPrice.text = String(price)
        }
        else {
            print("no dishes selected")
            editPrice.text = "0.0"
        }
    }
    
    // ---- INITIALIZE VIEW FUNCTION ----
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize stepper attributes
        stepTableNo.wraps = true
        stepTableNo.autorepeat = true
        stepTableNo.maximumValue = 12
        
        // initialize tableView properties
        tableDishes.allowsMultipleSelection = true
        
        // on startup, load the dishes db via retrieve()
        dishes = daoDish.retrieveAllDishes()
        print("Retrieved Dishes from db:\n")
        dishes.forEach{ dish in
            print(dish)
        }
        print("\n")
     }
    
    // ---- action functions ----
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
            stepTableNo.isEnabled = false
            textTableNum.alpha = 0.0
        }
        else {
            stepTableNo.isEnabled = true
            textTableNum.alpha = 1.0
        }
    }
    
    func addOrder() {
        
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
        if let selectedRows = tableDishes.indexPathsForSelectedRows {
            let selectedDishes = selectedRows.map { dishes[$0.row] }
            dishNames = daoDish.getSelectedDishNames(selectedDishes: selectedDishes)
        }
        
        print("\nRetrieved dish names:\n" + dishNames)
        
        // collet form data into a passable struct (i.e. string only struct)
        let order = OrderForm(
            orderID: editOrderID.text!,
            tableNum: tableNum,
            diningOpt: getDiningOpt(),
            dishes: dishNames,
            price: editPrice.text!)
        
        // push struct into DAO class for validation and db handling
        let results = daoOrder.addOrderForm(orderForm: order)
        
        // notify user of success/failure
        textResponse.text = results
        
        if results == "Item is added" {
            dismiss(animated: true)
        }
    }

    func getDiningOpt() -> String {
        return segDiningOpt.titleForSegment(at: segDiningOpt.selectedSegmentIndex)!
    }
    
    func loadImage(dish: String) -> UIImage? {
        
        // we get the image name from record (via DAO)
        let fileName = daoDish.getImageFromDishStr(dishStr: dish)
        
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
