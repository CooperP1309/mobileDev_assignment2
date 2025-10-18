//
//  DishAddViewController.swift
//  assignment2
//
//  Created by Cooper Peek on 5/10/2025.
//

import UIKit

class DishAddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // declare DAO object for all db operations
    var dao = DishDAO()
    var imagePicker: UIImagePickerController!
    
    // declaring of ui objects
    //  - buttons
    @IBOutlet weak var btnReturn: UIButton!
    @IBOutlet weak var btnSelectImage: UIButton!
    @IBOutlet weak var btnAddDish: UIButton!
    
    //  - edit text fields
    @IBOutlet weak var editDishId: UITextField!
    @IBOutlet weak var editDishName: UITextField!
    @IBOutlet weak var editIngredients: UITextField!
    @IBOutlet weak var editPrice: UITextField!
    
    //  - misc
    @IBOutlet weak var segDishType: UISegmentedControl!
    @IBOutlet weak var imageDish: UIImageView!
    
    //  - text fields
    @IBOutlet weak var textResponse: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = false // ensure to keep the bottom bar
    }
    
    @IBAction func btnReturnn(_ sender: Any) {
            dismiss(animated: true)
    }
    
    
    @IBAction func pressSelectImage(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func btnAddDish(_ sender: Any) {
        addDish()
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage{
            imageDish.image = image
            dismiss(animated:true, completion: nil)
        }
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
            image: saveImageToApp(image: imageDish.image))

        // push struct into DAO class for validation and db handling
        let results = dao.addDishForm(dishForm: dish)
        
        // notify user of success/failure
        textResponse.text = results
        
        if results == "Item is added" {
            dismiss(animated: true)
        }
    }
    
    func saveImageToApp(image:UIImage?)-> String {
        
        // convert it to jpg data for savability
        let imageData = image?.jpegData(compressionQuality: 0.8)
        
        if imageData == nil { // case for missing image
            return ""
        }
        
        // get the directory path of where we are going to save this file
        let docPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = UUID().uuidString + ".jpg"
        
        // complete the file path by appending the filename to the documents path
        let filePath = docPath.appendingPathComponent(fileName)
        
        do {
            try imageData!.write(to: filePath)
            print("Image saved at: \(filePath.path)")
            
            // return the image name for storage in DishDB
            // NOT ENTIRE PATH: Only name...
            return fileName
            
        } catch {
            print("Failed to write image: \(error)")
        }
        
        return ""
    }
}


