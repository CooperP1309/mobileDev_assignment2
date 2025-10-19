//
//  DishAddViewController.swift
//  assignment2
//
//  Created by Cooper Peek on 5/10/2025.
//

import UIKit

class DishUpdateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // declare DAO object for all db operations
    var dao = DishDAO()
    let docsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    var imagePicker: UIImagePickerController!
    
    // vars to get from List View
    var id = "", dishName = "", dishType = "", ingredients = "",
        price = "", image = ""
    
    // declaring of ui objects
    //  - buttons
    @IBOutlet weak var btnReturn: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnSelectImage: UIButton!
    
    //  - edit text fields
    @IBOutlet weak var editDishName: UITextField!
    @IBOutlet weak var editIngredients: UITextField!
    @IBOutlet weak var editPrice: UITextField!
    
    //  - misc
    @IBOutlet weak var segDishType: UISegmentedControl!
    @IBOutlet weak var imageDish: UIImageView!
    
    //  - text fields
    @IBOutlet weak var textResponse: UILabel!
    @IBOutlet weak var textDishId: UILabel!
  
    // ON START UP FUNC
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = false // ensure to keep the bottom bar
        
        imageDish.layer.borderWidth = 4               // thickness in points
        imageDish.layer.borderColor = UIColor.black.cgColor
        
        print("UpdateVC received:", id, dishName, dishType, ingredients, price, image)
        
        // setting of fields
        //editDishId.text = id
        textDishId.text = id
        editDishName.text = dishName
        setSegment(dishType: dishType)
        editIngredients.text = ingredients
        editPrice.text = price
        imageDish.image = loadImage(imageName: image)
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
    
    func loadImage(imageName: String) -> UIImage? {
        
        // check for empty imageName
        if imageName.isEmpty {
            return nil
        }

        // get the image from storage using image name
        let filePath = docsPath.appendingPathComponent(imageName)
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

    @IBAction func btnReturn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func btnUpdate(_ sender: Any) {
        updateDish()
    }
    
    @IBAction func pressSelectImage(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage{
            imageDish.image = image
            dismiss(animated:true, completion: nil)
        }
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
            image: updateImageToApp(image: imageDish.image))
        
        // push struct into DAO class for validation and db handling
        let results = dao.updateDishForm(dishForm: dish)
        
        // notify user of success/failure
        textResponse.text = results
        
        if results == "Update Successful" {
            dismiss(animated: true)
        }
    }
    
    func updateImageToApp(image:UIImage?)-> String {
        
        // convert it to jpg data for savability
        let imageData = image?.jpegData(compressionQuality: 0.8)
        
        // ensure to delete old
        deleteOriginalImage()
        
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
    
    func deleteOriginalImage() {
        
        if image.isEmpty {
            return          // abort if no image exists already
        }
        
        // declare a filemanager for this operation
        let filemanager = FileManager.default
        
        // build file path using the image name
        let filePath = docsPath.appendingPathComponent(image)
        
        do {
            try filemanager.removeItem(at: filePath)
            print("\nDishUpdate:\n  Previous image successfully removed from files:\n   \(filePath)")
        } catch {
            print("\nDishUpdate:\n  Failed to delete previous image:\n   \(filePath)")
        }
    }
}
