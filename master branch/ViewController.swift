//
//  ViewController.swift
//  master branch
//
//  Created by Jimmy  Payne on 2/13/17.
//  Copyright © 2017 Digidex iOS. All rights reserved.
//

//Test - Mike
//Test - Morgan
//Test - Jimmy

import UIKit

class ViewController: UIViewController {

    /* Key for items on view controller 
    LBL = Label, BTN = Button, TF = Text Field
    */
    // change 
    
    
    var loginMode = true
    
    @IBOutlet weak var homeImage: UIImageView!
    
    @IBOutlet weak var emailAddressTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var messageLBL: UILabel!
    
    @IBOutlet weak var isAdministratorSwitch: UISwitch!
    
    
    // this function creates an alert message that we can reuse later in this script
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
        
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func loginBTN(_ sender: Any) {
        if emailAddressTF.text == "" || passwordTF.text == "" {
            
            createAlert(title: "Error in form.", message: "Please enter an email and password.")
            
        } else {
            
            // here is where we would check to see if the user has signed up or not and is in the database.
            
            if loginMode {
                
                
                // this allows it to go through the log in screens because it is not in sign up mode
                self.performSegue(withIdentifier: "showLoginProcess", sender: self)
                
                // Log In PHP script would go below here along with other log in functionality
                
            }}
        
        
    }
    
    @IBAction func signupBTN(_ sender: Any) {
        
        // this allows it to go through the sign up screens because it is in sugnup mode
        self.performSegue(withIdentifier: "showSignupProcess", sender: self)
        
        // Sign Up PHP script will go below here along with other sign up finctionality

    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

