//
//  OrderDBManager.swift
//  assignment2
//
//  Created by Cooper Peek on 5/10/2025.
//

import UIKit
import CoreData

class OrderDBManager: NSObject {

    func addRow(orderFinal: OrderFinal)-> String{
        
        // set the core data to access the dish Entity and declare a context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return "AppDelegate error" } //use this in every function for DB
        let managedContext = appDelegate.persistentContainer.viewContext
        //use this in every function for DB
        
        let order = Order(context: managedContext)

        order.orderID = orderFinal.orderID
        order.tableNumber = orderFinal.tableNum
        order.diningOption = orderFinal.diningOpt
        order.dishes = orderFinal.dishes
        order.price = orderFinal.price
        
        do {
            try managedContext.save()
            print("Item is added")
            return "Item is added"
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func retrieveAllRows() -> String{
        var records = "" //for returning records
        
        // setting up app delegation
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return records
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // actual fetching of data
        let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
        do {
        let order = try managedContext.fetch(fetchRequest)
            for trans in order {
                //for each record, get the values
                let id = trans.orderID
                let tableNum = trans.tableNumber
                let diningOpt = trans.diningOption
                let dishes = trans.dishes
                let price = trans.price
            
                //add info to returning records
                records = records + "\(id), \(tableNum), \(diningOpt!), \(dishes!), \(price)\n"
            }
        }
        catch let error as NSError{
            print("Error \(error)")
        }
        return records
    }

    func retrieveById(theId:Int16)->String {
        var record = "" //for returning records
        
        // setting up app delegation
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return record
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // actual fetching of data
        let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
        //fetchRequest.predicate(format: "%K == %@", "id", id as CVarArg)
        
        // Make a predicate asking only for sessions of a certain "projectId"
        let query = NSPredicate(format: "orderID == %d", theId)
        fetchRequest.predicate = query
        fetchRequest.fetchLimit = 1 // Limit to one result as we're expecting a single object
        
        do {
        let order = try managedContext.fetch(fetchRequest)
            for trans in order {
                //for each record, get the values
                let orderID = trans.id
                let tableNum = trans.tableNumber
                let diningOpt = trans.diningOption
                let dishes = trans.dishes
                let price = trans.price
                
                //add info to returning records
                record = record + "\(orderID), \(tableNum), \(diningOpt!), \(dishes!), \(price)\n"
            }
        }
        catch let error as NSError{
            print("Error \(error)")
        }
        return record
    }
    
    func updateRow(orderFinal: OrderFinal)-> String{
        
        // set the core data to access the dish Entity and declare a context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return "AppDelegate error" } //use this in every function for DB
        let managedContext = appDelegate.persistentContainer.viewContext
        //use this in every function for DB
        
         // actual fetching of data
         let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
         
         // Make a predicate asking only for sessions of a certain "projectId"
        let query = NSPredicate(format: "orderID == %d", orderFinal.orderID)
         fetchRequest.predicate = query
         fetchRequest.fetchLimit = 1 // Limit to one result as we're expecting a single object
      
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            // if a dish is found
            if let targetOrder = results.first {
                
                // updating of fetched dishes fields
                targetOrder.setValue(orderFinal.orderID, forKey: "orderID")
                targetOrder.setValue(orderFinal.tableNum, forKey: "tableNumber")
                targetOrder.setValue(orderFinal.diningOpt, forKey: "diningOption")
                targetOrder.setValue(orderFinal.dishes, forKey: "dishes")
                targetOrder.setValue(orderFinal.price, forKey: "price")
                
                // make sure to save changes in storage (not just memory)
                try managedContext.save()
            }
            else {
                return "No Record Found"
            }
            
        } catch let error as NSError {
            print ("Failed to fetch for update: \(error), \(error.userInfo)")
            return "Update Failed"
        }
        
        return "Update Successful"
    }
    
    func deleteRowById(id: Int16)-> String{
        
        // set the core data to access the dish Entity and declare a context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return "AppDelegate error" } //use this in every function for DB
        let managedContext = appDelegate.persistentContainer.viewContext
        //use this in every function for DB
        
         // actual fetching of data
         let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
         //fetchRequest.predicate(format: "%K == %@", "id", id as CVarArg)
         
         // Make a predicate asking only for sessions of a certain "projectId"
        let query = NSPredicate(format: "orderID == %d", id)
         fetchRequest.predicate = query
         fetchRequest.fetchLimit = 1 // Limit to one result as we're expecting a single object
      
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            // if a dish is found
            if let targetOrder = results.first {
                
                managedContext.delete(targetOrder)
                
                // make sure to save changes in storage (not just memory)
                try managedContext.save()
            }
            else {
                return "No Record Found"
            }
            
        } catch let error as NSError {
            print ("Failed to fetch for update: \(error), \(error.userInfo)")
            return "Update Failed"
        }
        
        return "Delete Successful"
    }
}


