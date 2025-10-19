//
//  SessionLogin.swift
//  assignment2
//
//  Created by Cooper Peek on 19/10/2025.
//

import Foundation

struct Session {
    static var username = ""
    static var accessLevel = 0
    
    static func clear() {
        username = ""
        accessLevel = 0
    }
}
