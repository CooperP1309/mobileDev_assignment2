//
//  OrderFinal.swift
//  assignment2
//
//  Created by Cooper Peek on 10/10/2025.
//

import Foundation

struct OrderProg{
    var orderID: Int16
    var isDone: Bool
    var timeCompleted: String
    var timeCreated: String
    
    init(orderID: Int16, isDone: Bool, timeCompleted: String, timeCreated: String) {
        self.orderID = orderID
        self.isDone = isDone
        self.timeCompleted = timeCompleted
        self.timeCreated = timeCreated
    }
    
    init(orderID: Int16) {
        self.orderID = orderID
        self.isDone = false
        self.timeCompleted = "not completed"
        
        let date = Date()
        let isoFormatter = ISO8601DateFormatter()
        self.timeCreated = isoFormatter.string(from: date)
    }
}

