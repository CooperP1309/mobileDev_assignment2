//
//  OrderDAO.swift
//  assignment2
//
//  Created by Cooper Peek on 10/10/2025.
//

import Foundation

class OrderProgDAO {
    
    // declare db manager object
    var db = OrderProgressDBManager()
    
    // func pass Order ID to initialize a new progress tracker
    func addOrderProg(orderID: Int16) {
        
        // generate a new order progress object
        let order = OrderProg(orderID: orderID)
        
        // just loggin stuff
        print("\nOrderProgDAO:\n    ORDER with ID: \(orderID) Created at: \(order.timeCreated)")

        // actually push into database
        let result = db.addRow(orderProg: order)
        print("OrderProgDB: \(result)")
        
        return
    }
    
    func getProcessTimeFromID(orderID: Int) -> String {
        
        // search by ID the database
        let orderProg = db.retrieveById(theId: Int16(orderID))
        if orderProg.orderID == 0 {
            return "Error"
        }
        
        // determine if to show time since created or completed time
        var processTime = ""
        if !orderProg.isDone {
            
            // convert stored time created into a date object
            let isoFormatter = ISO8601DateFormatter()
            let date = isoFormatter.date(from: orderProg.timeCreated)!
            
            // get the difference since now
            let secondsElapsed = -date.timeIntervalSinceNow
            let minutes = Int(secondsElapsed) / 60
            let remainingSeconds = Int(secondsElapsed) % 60
            processTime = "Cooking for \(minutes) minutes and \(remainingSeconds) secs"
        }
        else {
            processTime = "Completed in "
            processTime.append(String(orderProg.timeCompleted))
        }
     
        return processTime
    }
    
    func markAsDone(orderID: Int) -> String {
        
        // get the current OrderProg record (given the ID)
        var orderProg = db.retrieveById(theId: Int16(orderID))
        
        // set completion time (and mark boolean field as done)
        let isoFormatter = ISO8601DateFormatter()
        let date = isoFormatter.date(from: orderProg.timeCreated)!      // initialize new Date obj using time created
        
        // get the difference since now
        let secondsElapsed = -date.timeIntervalSinceNow
        let minutes = Int(secondsElapsed) / 60
        let remainingSeconds = Int(secondsElapsed) % 60
        orderProg.timeCompleted = "\(minutes) minutes and \(remainingSeconds) secs"
        orderProg.isDone = true
        
        // update in the db
        let result = db.updateRow(orderProg: orderProg)
        
        return "\(result): Order \(orderProg.orderID) is done = \(orderProg.isDone) "
    }
    
    /*
    func updateOrderForm(orderForm: OrderForm) -> String {
        
        // validate each property of dish struct
        if !validateUpdateForm(orderForm: orderForm).isEmpty {
            print("\norder validation failed")
            return validateUpdateForm(orderForm: orderForm)
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
        
        let result = db.updateRow(orderFinal: order)
        
        return result
    }
    
    func deleteOrder(id: String) -> String {
        
        let result = db.deleteRowById(id: Int16(id)!)
        
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
    
    func validateUpdateForm(orderForm: OrderForm)->String {
        
        print("\nValidating order...")
        
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
    
    func deleteManyFromStrings(orders: [String]) {
        
        print("DELETING THE FOLLOWING ORDERS:")
        for order in orders {
            print(order)
        }
        
        // extract the id of each order and delete it
        for order in orders {
            let orderForm = self.stringToOrderForm(string: order)
            let result = self.deleteOrder(id: orderForm.orderID)
            print(result)
        }
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
            
            var order = line
            
            if self.isTakeAwayOrder(order: order) {
                order = self.setTakeAwayTableNum(order: line)
            }
            
            sortedRecords.append(order)
        }
        
        return sortedRecords
    }
    
    func isTakeAwayOrder(order: String) -> Bool {
        
        // extract the dining type
        var startIndex = getIndexOfNthComma(order: order, n: 2)
        let endIndex = getIndexOfNthComma(order: order, n: 3)
        var extractedDiningOpt = ""
        
        while startIndex < endIndex {
            extractedDiningOpt.append(order[startIndex])
            
            // REMEMBER TO INCREMENT
            startIndex = order.index(after: startIndex)
        }
        
        // final processing of dining opt buffer
        extractedDiningOpt.removeLast()
        let diningOpt = extractedDiningOpt.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if diningOpt == "Take Away" {
            print("DETECTED TAKEAWAY FROM: " + order)
            return true
        }
        
        return false
    }
    
    func setTakeAwayTableNum(order:String) -> String{   // for takeaway, we display table num as N/A
        
        var startIndex1 = order.startIndex
        let endIndex1 = getIndexOfNthComma(order: order, n: 1)
        var startIndex2 = getIndexOfNthComma(order: order, n: 2)
        let endIndex2 = order.endIndex
        var tableNumBuffer = ""
        
        // appending of first half
        while startIndex1 < endIndex1 {
            tableNumBuffer.append(order[startIndex1])
            
            // REMEMBER TO INCREMENT
            startIndex1 = order.index(after: startIndex1)
        }
        
        tableNumBuffer.append(" N/A,")
        
        // appending of remain half
        while startIndex2 < endIndex2 {
            tableNumBuffer.append(order[startIndex2])
            
            // REMEMBER TO INCREMENT
            startIndex2 = order.index(after: startIndex2)
        }
        
        print("PRODUCE RECORD:\n" + tableNumBuffer)
        
        return tableNumBuffer
    }
    
    func getIndexOfNthComma(order: String, n: Int) -> String.Index {
        
        var count = 0, currentIndex = order.startIndex
        
        while currentIndex < order.endIndex {
            if order[currentIndex] == "," {
                count += 1
            }
            
            // remember to increment before possible break as not to include comma itself
            currentIndex = order.index(after: currentIndex)
            if count == n { // end loop once the desired occurence is met
                break
            }
        }
        
        return currentIndex
    }
    
    func stringToOrderForm(string: String) -> OrderForm {
        
        var properties = string.components(separatedBy:",")
        
        // usual logging
        print("Converting String: " + string + "\n" )
        print("Resulting order properties:\n")
        properties.forEach{ order in
            print(order)
        }

        // remove whitespaces
        properties = properties.map {$0.trimmingCharacters(in: .whitespaces)}
        
        let order = OrderForm(
            orderID: properties[0],
            tableNum: properties[1],
            diningOpt: properties[2],
            dishes: properties[3],
            price: properties[4])
            
        return order
    }
     */
}
