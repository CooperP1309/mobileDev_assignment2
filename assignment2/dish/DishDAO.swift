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
    
    func getPriceFromSelected(dishArray: [String]) -> Float {
        
        var totalPrice: Float = 0.0
        
        // iterate through dish array
        for dish in dishArray {
            totalPrice += getPriceFromDishString(dish: dish)
        }
        
        return totalPrice
    }
    
    func getPriceFromDishString(dish: String) -> Float {
        
        // get the indexes of the price section in dish string
        let startPriceIndex = getIndexOfNthComma(dish: dish, n: 4)
        let endPriceIndex = getIndexOfNthComma(dish: dish, n: 5)
        var currentIndex = startPriceIndex
        
        // temporary string to extract price into
        var priceBuffer: String = ""
        
        while currentIndex < endPriceIndex {
            priceBuffer.append(dish[currentIndex])
            
            // remember to increment
            currentIndex = dish.index(after: currentIndex)
        }
        
        // final processing of price buffer
        priceBuffer.removeLast()
        let priceString = priceBuffer.trimmingCharacters(in: .whitespacesAndNewlines)
        //print("Extracted price from " + dish + ": " + priceString)
        
        return Float(priceString)!
    }
    
    func getIndexOfNthComma(dish: String, n: Int) -> String.Index {
        
        var count = 0, currentIndex = dish.startIndex
        
        while currentIndex < dish.endIndex {
            if dish[currentIndex] == "," {
                count += 1
            }
            
            // remember to increment before possible break as not to include comma itself
            currentIndex = dish.index(after: currentIndex)
            if count == n { // end loop once the desired occurence is met
                break
            }
        }
        
        return currentIndex
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
        var prevDishType: String = ""
        
        // iterate through each line in the "records" string
        records.enumerateLines {
            (line, stop) in
            
            // extract the dish type from each line
            let dish = self.stringToDishForm(string: line)
            
           // if a new dish type is found, insert a header record and re assign
            if dish.dishType != prevDishType {
                sortedRecords.append(dish.dishType)
                prevDishType = dish.dishType
            }
            
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
    
    func getSelectedDishNames(selectedDishes: [String]) -> String {
        
        var dishNames: String = ""
        
        for dish in selectedDishes {
            dishNames.append(getDishNameFromDishString(dish: dish))
            dishNames.append(" | ")
        }
        
        if selectedDishes.count != 0 {  // remove last appeneded divider
            dishNames.removeLast()
            dishNames.removeLast()
            dishNames.removeLast()      // im lazy and hate swift please ignore this
        }
        
        return dishNames
    }
    
    func getDishNameFromDishString(dish: String) -> String {
        
        var dishName: String = ""
        
        // get the indexes of the dish name section
        var startIndex = getIndexOfNthComma(dish: dish, n: 1)
        let endIndex = getIndexOfNthComma(dish: dish, n: 2)
        
        // extracting the name
        while startIndex < endIndex {
            dishName.append(dish[startIndex])
            
            // DONT FORGET TO INCREMENT
            startIndex = dish.index(after: startIndex)
        }
        
        print("Name extracted")
        
        // final processing of dishName
        dishName.removeLast()
        
        return dishName.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
