//
//  ViewController.swift
//  assignment2
//
//  Created by Cooper Peek on 5/10/2025.
//

import UIKit

class HomeViewController: UIViewController {
    
    // declare global vars
    var username: String = ""
    var accessLevel: Int = 0
    var loggedIn: Bool = false
    
    // delcare UI objects
    @IBOutlet weak var textWelcome: UILabel!
    
    @IBOutlet weak var btnLogout: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting view background
        let bg = UIImageView(frame: view.bounds)
            bg.image = UIImage(named: "homeBg")   // name from Assets.xcassets
        
            // screen fitting attributes
            bg.contentMode = .scaleAspectFit // start from Fit
            bg.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            bg.clipsToBounds = true

            // Apply a custom zoom factor
        bg.transform = CGAffineTransform(scaleX: 1.5, y: 1.5) // 1.0 = normal size, 1.2 = 20% zoom
            view.insertSubview(bg, at: 0)
        
            bg.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            view.insertSubview(bg, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if !loggedIn {
            performSegue(withIdentifier: "ShowLogin", sender: nil)
            loggedIn = true
        }
    }
    
    @IBAction func pressLogout(_ sender: Any) {
        
        // reset the static vars in Session
        Session.clear()
        
        // proceed with segue
        performSegue(withIdentifier: "ShowLogin", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier != "ShowLogin" {
            return
        }
        
        let destination = segue.destination as? LoginViewController
        destination!.loginDetails = { username, accessLevel in
            
            Session.username = username
            Session.accessLevel = accessLevel
            
            print("\nHomeView:\n    Session level: \(Session.accessLevel) User: \(Session.username)")
            
            self.textWelcome.font = UIFont.boldSystemFont(ofSize: 32)
            self.textWelcome.text = "Welcome back,\n\(Session.username)!"
        }
    }
}
