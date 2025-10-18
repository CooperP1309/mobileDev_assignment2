//
//  DishDBManager.swift
//  assignment2
//
//  Created by Cooper Peek on 5/10/2025.
//

import UIKit
import CoreData

class DishDBManager: NSObject {

    func addRow(dishFinal: DishFinal)-> String{
        
        // set the core data to access the dish Entity and declare a context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return "AppDelegate error" } //use this in every function for DB
        let managedContext = appDelegate.persistentContainer.viewContext //use this in every function for DB
        
        let dish = Dish(context: managedContext)
        dish.id = dishFinal.id
        dish.dishName = dishFinal.dishName
        dish.dishType = dishFinal.dishType
        dish.ingredients = dishFinal.ingredients
        dish.price = dishFinal.price
        dish.image = dishFinal.image
        
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
        let fetchRequest: NSFetchRequest<Dish> = Dish.fetchRequest()
        
        // initializing and attaching of sort descriptor to fetch request
        let sortDescriptor = NSSortDescriptor(key: "dishType", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
        let dish = try managedContext.fetch(fetchRequest)
            for trans in dish {
                //for each record, get the values
                let id = trans.id
                let name = trans.dishName
                let type = trans.dishType
                let ingredients = trans.ingredients
                let price = trans.price
                let image = trans.image
                //add info to returning records
                records = records + "\(id), \(name!), \(type!), \(ingredients!), \(price), \(image!) \n"
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
        let fetchRequest: NSFetchRequest<Dish> = Dish.fetchRequest()
        //fetchRequest.predicate(format: "%K == %@", "id", id as CVarArg)
        
        // Make a predicate asking only for sessions of a certain "projectId"
        let query = NSPredicate(format: "id == %d", theId)
        fetchRequest.predicate = query
        fetchRequest.fetchLimit = 1 // Limit to one result as we're expecting a single object
        
        do {
        let dish = try managedContext.fetch(fetchRequest)
            for trans in dish {
                //for each record, get the values
                let id = trans.id
                let name = trans.dishName
                let type = trans.dishType
                let ingredients = trans.ingredients
                let price = trans.price
                let image = trans.image
                //add info to returning records
                record = record + "\(id), \(name!), \(type!), \(ingredients!), \(price), \(image!)\n"
            }
        }
        catch let error as NSError{
            print("Error \(error)")
        }
        return record
    }
    
    func updateRow(dishFinal: DishFinal)-> String{
        
        // set the core data to access the dish Entity and declare a context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return "AppDelegate error" } //use this in every function for DB
        let managedContext = appDelegate.persistentContainer.viewContext
        //use this in every function for DB
        
         // actual fetching of data
         let fetchRequest: NSFetchRequest<Dish> = Dish.fetchRequest()
         //fetchRequest.predicate(format: "%K == %@", "id", id as CVarArg)
         
         // Make a predicate asking only for sessions of a certain "projectId"
        let query = NSPredicate(format: "id == %d", dishFinal.id)
         fetchRequest.predicate = query
         fetchRequest.fetchLimit = 1 // Limit to one result as we're expecting a single object
      
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            // if a dish is found
            if let targetDish = results.first {
                
                // updating of fetched dishes fields
                targetDish.setValue(dishFinal.id, forKey: "id")
                targetDish.setValue(dishFinal.dishName, forKey: "dishName")
                targetDish.setValue(dishFinal.dishType, forKey: "dishType")
                targetDish.setValue(dishFinal.ingredients, forKey: "ingredients")
                targetDish.setValue(dishFinal.price, forKey: "price")
                targetDish.setValue(dishFinal.image, forKey: "image")
                
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
         let fetchRequest: NSFetchRequest<Dish> = Dish.fetchRequest()
         //fetchRequest.predicate(format: "%K == %@", "id", id as CVarArg)
         
         // Make a predicate asking only for sessions of a certain "projectId"
        let query = NSPredicate(format: "id == %d", id)
         fetchRequest.predicate = query
         fetchRequest.fetchLimit = 1 // Limit to one result as we're expecting a single object
      
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            // if a dish is found
            if let targetDish = results.first {
                
                managedContext.delete(targetDish)
                
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
    
    func retrieveByName(theName: String)->String {
        var record = "" //for returning records
        
        // setting up app delegation
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return record
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // actual fetching of data
        let fetchRequest: NSFetchRequest<Dish> = Dish.fetchRequest()
        //fetchRequest.predicate(format: "%K == %@", "id", id as CVarArg)
        
        // Make a predicate asking only for sessions of a certain "projectId"
        let query = NSPredicate(format: "dishName == %@", theName)
        fetchRequest.predicate = query
        fetchRequest.fetchLimit = 1 // Limit to one result as we're expecting a single object
        
        do {
        let dish = try managedContext.fetch(fetchRequest)
            for trans in dish {
                //for each record, get the values
                let id = trans.id
                let name = trans.dishName
                let type = trans.dishType
                let ingredients = trans.ingredients
                let price = trans.price
                let image = trans.image
                //add info to returning records
                record = record + "\(id), \(name!), \(type!), \(ingredients!), \(price), \(image!)\n"
            }
        }
        catch let error as NSError{
            print("Error \(error)")
        }
        return record
    }
}


