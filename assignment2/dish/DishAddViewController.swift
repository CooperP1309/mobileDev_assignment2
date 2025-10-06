//
//  DishAddViewController.swift
//  assignment2
//
//  Created by Cooper Peek on 5/10/2025.
//

import UIKit

class DishAddViewController: UIViewController {

    // declare DAO object for all db operations
    var dao = DishDAO()
    
    // declaring of ui objects
    //  - buttons
    @IBOutlet weak var btnReturn: UIButton!
    @IBOutlet weak var btnAddDish: UIButton!
    
    //  - edit text fields
    @IBOutlet weak var editDishId: UITextField!
    @IBOutlet weak var editDishName: UITextField!
    @IBOutlet weak var editIngredients: UITextField!
    @IBOutlet weak var editPrice: UITextField!
    
    //  - segment
    @IBOutlet weak var segDishType: UISegmentedControl!
    
    //  - text fields
    @IBOutlet weak var textResponse: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = false // ensure to keep the bottom bar
    }
    
    @IBAction func btnReturnn(_ sender: Any) {
            dismiss(animated: true)
    }
    
    @IBAction func btnAddDish(_ sender: Any) {
        addDish()
        dismiss(animated: true)
    }
    
    func addDish() {
        
        // collet form data into a passable struct (i.e. string only)
        let dish = DishForm(
            id: editDishId.text!,
            dishName: editDishName.text!,
            dishType: segDishType.titleForSegment(at:
                      segDishType.selectedSegmentIndex)!,
            ingredients: editIngredients.text!,
            price: editPrice.text!,
            image: " ")

        // push struct into DAO class for validation and db handling
        let results = dao.addDishForm(dishForm: dish)
        
        // notify user of success/failure
        textResponse.text = results
    }
}


