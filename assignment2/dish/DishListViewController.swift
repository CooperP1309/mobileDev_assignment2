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
    var selectedRows: [IndexPath] = []
    
    // declare a pointer to where images are saved
    let docsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    // dish db data struct
    var dishes: [String] = []
    
    // variable to send to update fields
    var id = "", dishName = "", dishType = "", ingredients = "", price = "", image = ""
    
    // declaring buttons
    @IBOutlet weak var btnAddDishForm: UIButton!
    @IBOutlet weak var btnEditDish: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    // declaring text objects
    @IBOutlet weak var textResponse: UILabel!
    @IBOutlet weak var textWelcome: UILabel!
    
    // main table view for dishes
    @IBOutlet weak var tableView: UITableView!
    
    // START UP FUNC
    override func viewDidLoad() {
        super.viewDidLoad()

        // by default, nothing is selected...
        btnDelete.isEnabled = false
        btnEditDish.isEnabled = false
        
        // allow cells to fit many lines
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 88
        tableView.allowsMultipleSelection = true
        
        // on startup, load the dishes db via retrieve()
        dishes = dao.retrieveAllDishes()
        dishes.forEach{ dish in
            print(dish)
        }
    }

    // RELOAD FUNC
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // by default, nothing is selected...
        btnDelete.isEnabled = false
        btnEditDish.isEnabled = false
        
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
        
        // setting row params and loading dish data
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        // set as the record without its image name
        cell.textLabel!.text = dao.stripImageFromDishStr(dishStr: dishes[indexPath.row])
        
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
        handleSelectedRows()
    }
    
    // handler for when a cell is DEselected
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        handleSelectedRows()
    }
    
    func handleSelectedRows() {
    
        if tableView.indexPathsForSelectedRows == nil {
            btnDelete.isEnabled = false
            btnEditDish.isEnabled = false
            return
        }
   
        selectedRows = tableView.indexPathsForSelectedRows!
        
        if selectedRows.count > 1 {
            btnEditDish.isEnabled = false
            return
        }
        
        btnDelete.isEnabled = true
        btnEditDish.isEnabled = true
    }
    
    
    // ---- action and misc function ----
    
    @IBAction func pressDelete(_ sender: Any) {
        
        // get each selected orders
        let selectedDishes = selectedRows.map { dishes[$0.row] }
        
        // delete them orders
        dao.deleteManyFromStrings(dishes: selectedDishes)
        
        // refresh the data
        dishes = dao.retrieveAllDishes()
        tableView.reloadData()
        btnDelete.isEnabled = false
    }
    
    func loadImage(dish: String) -> UIImage? {
        
        // we get the image name from record (via DAO)
        let fileName = dao.getImageFromDishStr(dishStr: dish)
        
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
