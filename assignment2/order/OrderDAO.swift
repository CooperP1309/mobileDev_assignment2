//
//  OrderDAO.swift
//  assignment2
//
//  Created by Cooper Peek on 10/10/2025.
//

import Foundation

class OrderDAO {
    
    // declare db manager object
    var db = OrderDBManager()
    
    // func pass Order Form data
    func addOrderForm(orderForm: OrderForm) -> String {
        
        // validate each property of dish struct
        if !validateOrderForm(orderForm: orderForm).isEmpty {
            print("\norder validation failed")
            return validateOrderForm(orderForm: orderForm)
        }
        
        print("\nvalidation passed, pushing order to db:\n" +
              "id: " + orderForm.orderID + "\n" +
              "tableNum: " + orderForm.tableNum + "\n" +
              "Dining Type: " + orderForm.diningOpt + "\n" +
              "Dishes: " + orderForm.dishes + "\n" +
              "Price: " + orderForm.price)
        
        
        // extract each property and package in type appropriate struct
        let order = OrderFinal(
                orderID: Int16(orderForm.orderID)!,
                tableNum: Int16(orderForm.tableNum)!,
                diningOpt: orderForm.diningOpt,
                dishes: orderForm.dishes,
                price: Float(orderForm.price)!)
        
        let result = db.addRow(orderFinal: order)
        
        return result
    }
    
    
    func validateOrderForm(orderForm: OrderForm)->String {
        
        print("\nValidating order...")
        
        // validate id
        if orderForm.orderID.isEmpty{
            return "No id selected"
        }
        if !isStringAnInt(stringNumber: orderForm.orderID) {
            return "Please use a number id"
        }
        if !db.retrieveById(theId: Int16(orderForm.orderID)!).isEmpty {
            return "Please choose an available id"
        }
        
        // validate dishName
        if orderForm.tableNum.isEmpty || !isStringAnInt(stringNumber: orderForm.tableNum) {
            return "Please enter a valid table number"
        }
        
        // validate dining opt
        if orderForm.diningOpt.isEmpty {
            return "Please enter a dining option"
        }
        
        // eat in -> table no logic
        if orderForm.diningOpt == "Eat In" && orderForm.tableNum == "0" {
            return "Please select a table number when eating in"
        }
        
        // validate dishes
        if orderForm.dishes.isEmpty {
            return "Please select a dish"
        }
        
        // validate price
        if orderForm.price.isEmpty {
            return "Please enter price"
        }
        if !isStringAFloat(stringNumber: orderForm.price) {
            return "Please use a decimal price"
        }
        
        return ""
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
    
    func retrieveAllOrders()->[String] {
        
        // get all dishes in a string
        let orders = db.retrieveAllRows()
        
        // sort said dishes into string arra
        var sortedOrders: [String] = []
        sortedOrders = sortRecords(records:orders)
        
        return sortedOrders
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
}
