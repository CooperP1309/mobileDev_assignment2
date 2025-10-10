//
//  OrderForm.swift
//  assignment2
//
//  Created by Cooper Peek on 10/10/2025.
//

import Foundation

struct OrderForm {
    var orderID: String
    var tableNum : String
    var diningOpt: String
    var dishes: String
    var price: String
    
    init(orderID: String, tableNum: String, diningOpt: String, dishes: String, price: String) {
        self.orderID = orderID
        self.tableNum = tableNum
        self.diningOpt = diningOpt
        self.dishes = dishes
        self.price = price
    }
}
