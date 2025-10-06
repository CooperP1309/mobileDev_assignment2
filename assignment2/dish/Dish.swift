//
//  DishForm.swift
//  assignment2
//
//  Created by Cooper Peek on 5/10/2025.
//

// this struct holds the type appropriate dish properties for submission in db entity

import Foundation

struct DishFinal {
    var id: Int16
    var dishName: String
    var dishType: String
    var ingredients: String
    var price: Float
    var image: String
    
    init(id: Int16, dishName: String, dishType: String, ingredients: String, price: Float, image: String) {
        self.id = id
        self.dishName = dishName
        self.dishType = dishType
        self.ingredients = ingredients
        self.price = price
        self.image = image
    }
}

