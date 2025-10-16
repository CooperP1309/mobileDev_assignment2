//
//  OrderDBManager.swift
//  assignment2
//
//  Created by Cooper Peek on 5/10/2025.
//

import UIKit
import CoreData

class OrderProgressDBManager: NSObject {

    func addRow(orderProg: OrderProg)-> String{
        
        // set the core data to access the dish Entity and declare a context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return "AppDelegate error" } //use this in every function for DB
        let managedContext = appDelegate.persistentContainer.viewContext
        //use this in every function for DB
        
        let order = OrderProgress(context: managedContext)

        order.orderID = orderProg.orderID
        order.isDone = orderProg.isDone
        order.timeCompleted = orderProg.timeCompleted
        order.timeCreated = orderProg.timeCreated
        
        do {
            try managedContext.save()
            print("Item is added")
            return "Item is added"
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func retrieveById(theId:Int16)->OrderProg {
        var orderProg = OrderProg(orderID: 0,
                                  isDone: false,
                                  timeCompleted: "",
                                  timeCreated: "")
        
        // setting up app delegation
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return orderProg
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // actual fetching of data
        let fetchRequest: NSFetchRequest<OrderProgress> = OrderProgress.fetchRequest()
        //fetchRequest.predicate(format: "%K == %@", "id", id as CVarArg)
        
        // Make a predicate asking only for sessions of a certain "projectId"
        let query = NSPredicate(format: "orderID == %d", theId)
        fetchRequest.predicate = query
        fetchRequest.fetchLimit = 1 // Limit to one result as we're expecting a single object
        
        do {
        let order = try managedContext.fetch(fetchRequest)
            for trans in order {
                
                //for each record, get the values
                //let id = trans.id
                
                let tempOrderProg = OrderProg(
                    orderID: trans.orderID,
                    isDone: trans.isDone,
                    timeCompleted: trans.timeCompleted!,
                    timeCreated: trans.timeCreated!)
                
                orderProg = tempOrderProg
            }
        }
        catch let error as NSError{
            print("Error \(error)")
        }
        
        return orderProg
    }
    
    func updateRow(orderProg: OrderProg)-> String{
        
        // set the core data to access the dish Entity and declare a context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return "AppDelegate error" } //use this in every function for DB
        let managedContext = appDelegate.persistentContainer.viewContext
        //use this in every function for DB
        
         // actual fetching of data
         let fetchRequest: NSFetchRequest<OrderProgress> = OrderProgress.fetchRequest()
         
         // Make a predicate asking only for sessions of a certain "projectId"
        let query = NSPredicate(format: "orderID == %d", orderProg.orderID)
         fetchRequest.predicate = query
         fetchRequest.fetchLimit = 1 // Limit to one result as we're expecting a single object
      
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            // if a dish is found
            if let targetOrder = results.first {
                
                // updating of fetched dishes fields
                targetOrder.setValue(orderProg.orderID, forKey: "orderID")
                targetOrder.setValue(orderProg.isDone, forKey: "isDone")
                targetOrder.setValue(orderProg.timeCompleted, forKey: "timeCompleted")
                targetOrder.setValue(orderProg.timeCreated, forKey: "timeCreated")
                
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
    
    /*
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

    
    
    func updateRow(orderProg: orderProg)-> String{
        
        // set the core data to access the dish Entity and declare a context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return "AppDelegate error" } //use this in every function for DB
        let managedContext = appDelegate.persistentContainer.viewContext
        //use this in every function for DB
        
         // actual fetching of data
         let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
         
         // Make a predicate asking only for sessions of a certain "projectId"
        let query = NSPredicate(format: "orderID == %d", orderProg.orderID)
         fetchRequest.predicate = query
         fetchRequest.fetchLimit = 1 // Limit to one result as we're expecting a single object
      
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            // if a dish is found
            if let targetOrder = results.first {
                
                // updating of fetched dishes fields
                targetOrder.setValue(orderProg.orderID, forKey: "orderID")
                targetOrder.setValue(orderProg.tableNum, forKey: "tableNumber")
                targetOrder.setValue(orderProg.diningOpt, forKey: "diningOption")
                targetOrder.setValue(orderProg.dishes, forKey: "dishes")
                targetOrder.setValue(orderProg.price, forKey: "price")
                
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
     */
}


