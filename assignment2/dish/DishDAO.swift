//
//  DishDAO.swift
//  assignment2
//
//  Created by Cooper Peek on 6/10/2025.
//

import Foundation

class DishDAO {
    
    // db manager allows each func direct access to db
    var db = DishDBManager()
    
    // pass DishForm struct
    func addDishForm(dishForm: DishForm)->String {
        
        // validate each property of dish struct
        if !validateDishForm(dishForm: dishForm).isEmpty {
            return validateDishForm(dishForm: dishForm)
        }
        
        // extract each property and package in type appropriate struct
        let dish = DishFinal(
            id: Int16(dishForm.id)!,
            dishName: dishForm.dishName,
            dishType: dishForm.dishType,
            ingredients: sortIngredients(ingredients: dishForm.ingredients),
            price: Float(dishForm.price)!,
            image: dishForm.image)
        
        let result = db.addRow(dishFinal: dish)
        
        return result
    }
    
    func updateDishForm(dishForm: DishForm)->String {
        
        // validate each property of dish struct
        if !validateDishFormWithoutID(dishForm: dishForm).isEmpty {
            return validateDishFormWithoutID(dishForm: dishForm)
        }
        
        // extract each property and package in type appropriate struct
        let dish = DishFinal(
            id: Int16(dishForm.id)!,
            dishName: dishForm.dishName,
            dishType: dishForm.dishType,
            ingredients: sortIngredients(ingredients: dishForm.ingredients),
            price: Float(dishForm.price)!,
            image: dishForm.image)
        
        let result = db.updateRow(dishFinal: dish)
        
        return result
    }
    
    func deleteDish(id: String) -> String {
        
        let result = db.deleteRowById(id: Int16(id)!)
        
        return result
    }
    
    func validateDishForm(dishForm: DishForm)->String {
        
        // validate id
        if dishForm.id.isEmpty{
            return "No id selected"
        }
        if !isStringAnInt(stringNumber: dishForm.id) {
            return "Please use a number id"
        }
        if !db.retrieveById(theId: Int16(dishForm.id)!).isEmpty {
            return "Please choose an available id"
        }
        
        // validate dishName
        if dishForm.dishName.isEmpty {
            return "Please enter a dish name"
        }
        
        // validate dishType
        if dishForm.dishType.isEmpty {
            return "Please enter a dish type"
        }
        
        // validate ingredients
        if dishForm.ingredients.isEmpty {
            return "Please enter ingredients"
        }
        
        // validate price
        if dishForm.price.isEmpty {
            return "Please enter price"
        }
        if !isStringAFloat(stringNumber: dishForm.price) {
            return "Please use a decimal price"
        }
        
        return ""
    }
    
    func validateDishFormWithoutID(dishForm: DishForm)->String {
        
        // validate id
        if dishForm.id.isEmpty{
            return "No id selected"
        }
        if !isStringAnInt(stringNumber: dishForm.id) {
            return "Please use a number id"
        }
        
        // validate dishName
        if dishForm.dishName.isEmpty {
            return "Please enter a dish name"
        }
        
        // validate dishType
        if dishForm.dishType.isEmpty {
            return "Please enter a dish type"
        }
        
        // validate ingredients
        if dishForm.ingredients.isEmpty {
            return "Please enter ingredients"
        }
        
        // validate price
        if dishForm.price.isEmpty {
            return "Please enter price"
        }
        if !isStringAFloat(stringNumber: dishForm.price) {
            return "Please use a decimal price"
        }
        
        return ""
    }
    
    func retrieveAllDishes()->[String] {
        
        // get all dishes in a string
        let dishes = db.retrieveAllRows()
        
        // sort said dishes into string arra
        var sortedDishes: [String] = []
        sortedDishes = sortRecords(records:dishes)
        
        return sortedDishes
    }
    
    func sortRecords(records:String)->[String] {
        
        // declare memory for the sorted records
        var sortedRecords: [String] = []
        
        // iterate through each line in the "records" string
        records.enumerateLines {
            (line, stop) in
            sortedRecords.append(line)
        }
        
        return sortedRecords
    }
    
    func isStringAnInt(stringNumber: String) -> Bool {
        
        if let _ = Int(stringNumber) {
            return true
        }
        return false
    }
    
    func isStringAFloat(stringNumber: String) -> Bool {

        if let _ = Float(stringNumber) {
            return true
        }
        return false
    }
    
    func stringToDishForm(string: String)->DishForm {
        
        var properties = string.components(separatedBy:",")
        
        // usual logging
        print("Converting String: " + string + "\n" )
        print("Resulting dish properties:\n")
        properties.forEach{ dish in
            print(dish)
        }

        // remove whitespaces
        properties = properties.map {$0.trimmingCharacters(in: .whitespaces)}
        
        let dish = DishForm(
                    id: properties[0],
                    dishName: properties[1],
                    dishType: properties[2],
                    ingredients: properties[3],
                    price: properties[4],
                    image: properties.count > 5 ? properties[5] : ""
        )
        // note how image is option; thus check if it exists before assigning
        
        return dish
    }
    
    func sortIngredients(ingredients: String) -> String{
        
        let newIngredients = ingredients.replacingOccurrences(of: ",", with: "|")
        
        return newIngredients
    }
}
