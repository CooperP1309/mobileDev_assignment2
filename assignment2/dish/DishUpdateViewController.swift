//
//  DishAddViewController.swift
//  assignment2
//
//  Created by Cooper Peek on 5/10/2025.
//

import UIKit

class DishUpdateViewController: UIViewController {
    
    // declare DAO object for all db operations
    var dao = DishDAO()
    
    // vars to get from List View
    var id = "", dishName = "", dishType = "", ingredients = "",
        price = "", image = ""
    
    // declaring of ui objects
    //  - buttons
    @IBOutlet weak var btnReturn: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    //  - edit text fields
    @IBOutlet weak var editDishName: UITextField!
    @IBOutlet weak var editIngredients: UITextField!
    @IBOutlet weak var editPrice: UITextField!
    
    //  - segment
    @IBOutlet weak var segDishType: UISegmentedControl!
    
    //  - text fields
    @IBOutlet weak var textResponse: UILabel!
    @IBOutlet weak var textDishId: UILabel!
  
    // ON START UP FUNC
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = false // ensure to keep the bottom bar
        
        print("UpdateVC received:", id, dishName, dishType, ingredients, price)
        
        // setting of fields
        //editDishId.text = id
        textDishId.text = id
        editDishName.text = dishName
        setSegment(dishType: dishType)
        editIngredients.text = ingredients
        editPrice.text = price
        // IMAGE HANDLING HERE
    }
    
    func setSegment(dishType: String) {
        
        switch dishType {
        case "Drink":
            segDishType.selectedSegmentIndex = 0
            break
        
        case "Entree":
            segDishType.selectedSegmentIndex = 1
            break
            
        case "Main":
            segDishType.selectedSegmentIndex = 2
            break
            
        default:
            break
        }
    }

    @IBAction func btnReturn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func btnUpdate(_ sender: Any) {
        updateDish()
        dismiss(animated: true)
    }
    
    @IBAction func btnDelete(_ sender: Any) {
        let result = dao.deleteDish(id:id)
        textResponse.text = result
        
        // return afterwards
        dismiss(animated: true)
    }
    
    func updateDish() {
        
        // collet form data into a passable struct (i.e. string only)
        let dish = DishForm(
            //id: editDishId.text!,
            id: textDishId.text!,
            dishName: editDishName.text!,
            dishType: segDishType.titleForSegment(at:
                      segDishType.selectedSegmentIndex)!,
            ingredients: editIngredients.text!,
            price: editPrice.text!,
            image: " ")
        
        // push struct into DAO class for validation and db handling
        let results = dao.updateDishForm(dishForm: dish)
        
        // notify user of success/failure
        textResponse.text = results
    }
}
