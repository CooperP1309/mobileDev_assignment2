//
//  LoginViewController.swift
//  assignment2
//
//  Created by Cooper Peek on 19/10/2025.
//

import UIKit

class LoginViewController: UIViewController {

    // declare global vars
    var loginDetails: ((String, Int) -> Void)?
    var username = ""
    var password = ""
    var accessLevel: Int = 0
    
    // ---- declaring UI objects ----
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var editUsername: UITextField!
    @IBOutlet weak var textResponse: UILabel!
    @IBOutlet weak var editPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set password field as hidden type
        editPassword.isSecureTextEntry = true
        
        // setting view background
        let bg = UIImageView(frame: view.bounds)
            bg.image = UIImage(named: "loginBg")   // name from Assets.xcassets
        
            // screen fitting attributes
            bg.contentMode = .scaleAspectFit // start from Fit
            bg.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            bg.clipsToBounds = true

            // Apply a custom zoom factor
        bg.transform = CGAffineTransform(scaleX: 1.1, y: 1.5) // 1.0 = normal size, 1.2 = 20% zoom
            view.insertSubview(bg, at: 0)
        
            bg.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            view.insertSubview(bg, at: 0)
        
        // ensure each var is cleared on loading and reloading
        username = ""
        accessLevel = 0
        
    }

    @IBAction func pressLogin(_ sender: Any) {
        
        // get username and password
        username = editUsername.text!
        password = editPassword.text!
        
        if authenticate() {
            // send it to home page
            loginDetails?(username, accessLevel)
            
            // apply to Session struct
            //Session.accessLevel = accessLevel
            //Session.username = username
            
            print("\nLoginView:\n   Session setting details; username: \(username), accesslevel: \(accessLevel)")
            
            // finally return to the home page	
            dismiss(animated: true)
            return
        }
        
        textResponse.text = "Invalid username or password,\n please try again..."
    }
    
    func authenticate() -> Bool {

        if username == "Mary" && password == "123" {    // admin case
            accessLevel = 1
            return true
        }
        
        if username == "John" && password == "abc" {
            accessLevel = 2
            return true
        }
            
        return false
    }
}
