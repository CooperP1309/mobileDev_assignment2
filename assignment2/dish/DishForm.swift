//
//  DishForm.swift
//  assignment2
//
//  Created by Cooper Peek on 5/10/2025.
//

// struct allows for passing of dish form data for validation in DAO class
// because validation occurs after this is made, we store everything as strings

import Foundation

struct DishForm {
    var id: String
    var dishName: String
    var dishType: String
    var ingredients: String
    var price: String
    var image: String
    
    init(id: String, dishName: String, dishType: String, ingredients: String, price: String, image: String) {
        self.id = id
        self.dishName = dishName
        self.dishType = dishType
        self.ingredients = ingredients
        self.price = price
        self.image = image
    }
}

