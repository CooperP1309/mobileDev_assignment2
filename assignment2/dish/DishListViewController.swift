//
//  DishListViewController.swift
//  assignment2
//
//  Created by Cooper Peek on 5/10/2025.
//

import UIKit

class DishListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    // declaring DAO
    var dao = DishDAO()
    
    // dish db data struct
    var dishes: [String] = []
    
    // variable to send to update fields
    var id = "", dishName = "", dishType = "", ingredients = "", price = "", image = ""
    
    // declaring buttons
    @IBOutlet weak var btnAddDishForm: UIButton!
    
    // declaring text objects
    @IBOutlet weak var textResponse: UILabel!
    @IBOutlet weak var textWelcome: UILabel!
    
    // main table view for dishes
    @IBOutlet weak var tableView: UITableView!
    
    // START UP FUNC
    override func viewDidLoad() {
        super.viewDidLoad()

        // allow cells to fit many lines
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 88
        
        // on startup, load the dishes db via retrieve()
        dishes = dao.retrieveAllDishes()
        dishes.forEach{ dish in
            print(dish)
        }
    }

    // RELOAD FUNC
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // allow cells to have greater height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 88
        
        // actually retrieve data
        dishes = dao.retrieveAllDishes()
        tableView.reloadData()
    }
    
    @IBAction func btnAddDishForm(_ sender: Any) {
    }
    
    // ---- start of tableView methods ----
    
    // return number of rows in the TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes.count
    }
    
    // return the individual cell view given an index of a TableView
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
    
    // handler for when a cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // get the data at the selected cell (indexPath)
        let dish = dao.stringToDishForm(string: dishes[indexPath.row])
        
        id = dish.id
        dishName = dish.dishName
        dishType = dish.dishType
        ingredients = dish.ingredients
        price = dish.price
        image = dish.image
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier != "DishUpdateForm" {
            return
        }
        
        // Unwrap real destination (handles nav-controller wrapping)
        let destination: DishUpdateViewController
        if let nav = segue.destination as? UINavigationController,
           let top = nav.topViewController as? DishUpdateViewController {
            destination = top
        } else if let vc = segue.destination as? DishUpdateViewController {
            destination = vc
        } else {
            assertionFailure("Unexpected destination: \(segue.destination)")
            return
        }

        // Resolve selected row
        guard let ip = tableView.indexPathForSelectedRow else { return }

        // Build dish from your array
        let dish = dao.stringToDishForm(string: dishes[ip.row])
        destination.id = dish.id
        destination.dishName = dish.dishName
        destination.dishType = dish.dishType	
        destination.ingredients = dish.ingredients
        destination.price = dish.price
        destination.image = dish.image
    }

    
    // ---- end of tableView methods ----

}
