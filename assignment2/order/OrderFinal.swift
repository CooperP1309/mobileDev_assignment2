//
//  OrderFinal.swift
//  assignment2
//
//  Created by Cooper Peek on 10/10/2025.
//

import Foundation

struct OrderFinal {
    var orderID: Int16
    var tableNum: Int16
    var diningOpt: String
    var dishes: String
    var price: Float
    
    init(orderID: Int16, tableNum: Int16, diningOpt: String, dishes: String, price: Float) {
        self.orderID = orderID
        self.tableNum = tableNum
        self.diningOpt = diningOpt
        self.dishes = dishes
        self.price = price
    }
}

