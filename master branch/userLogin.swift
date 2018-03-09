//
//  userLogin.swift
//  Digidex iOS - Main File
//
//  Created by Morgan Baker on 3/6/17.
//  Copyright © 2017 Digidex iOS. All rights reserved.
//

import UIKit

var e = ""

class userLogin: UIViewController {
    
    //Setting Variables for the dictionary
    var name = ""
    var loginStatus = false
    var username = [String]()
    var user_info = [String : AnyObject]()
    var id = ""
    var e = ""
    
    //Weak outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let eObject = UserDefaults.standard.object(forKey: "e")
        if let e = eObject as? String {
            emailTextField.text = e
        }
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userLogin.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    //Action Button
    @IBAction func loginButtonTapped(_ sender: AnyObject) {
    
        let url = URL(string: "https://cgi.soic.indiana.edu/~team62/loginverification.php")
        
        //Getting to contents of user information into database
        do {
            let allUserInfo = try Data(contentsOf: url!)
            let allUsers = try JSONSerialization.jsonObject(with: allUserInfo, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : AnyObject]
            
            //Making array to sort through the index of the specific field
            if let array = allUsers["user_info"] as? [AnyObject] {
                for index in 0...array.count-1 {
                    let aObject = array[index] as! [String : AnyObject]
                    let Emails = aObject["email"] as! String
                    let Passwords = aObject["password"] as! String
                    user_info[Emails] = Passwords as AnyObject?
                    
                }
            }
        }
        catch{
        }
        //Making count to use as login toggle
        var count = 0
        
        //Setting paramaters for text fields to match database fields
        for (myKey, myValue) in user_info {
            print(myKey)
            print(myValue)
            let userEmail = emailTextField.text
            let userPassword = passwordTextField.text
            
        //Looping through the index to match myKey/myValue to email/password
            if userEmail == myKey {
                if userPassword! == myValue as! String {
                    count += 1
                }
            }
        }
        //The count determines whether to perform the segue
        if count > 0 {
            print("true")
            performSegue(withIdentifier: "showLoginProcess", sender: self)
        }
        //If the user is not found text fields erased
        else {
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
            
            createAlert(title: "Error", message: "Username or password incorrect.")
        }
        
    }
    
    //This function checks if something is in the form of an email
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    // this function creates an alert message that we can reuse later in this script
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        
        if isValidEmail(testStr: emailTextField.text!) && passwordTextField.text != "" {
            
            self.performSegue(withIdentifier: "showSignupProcess", sender: self)
            
        } else {
            
            createAlert(title: "Error", message: "Please enter a valid email and password.")
        }
        
        //created NSURL
        let URL = "https://cgi.soic.indiana.edu/~team62/signup.php"
        
        let requestURL = NSURL(string: URL)
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        //getting values from text fields
        let email = self.emailTextField.text
        let password = self.passwordTextField.text

        
        //Display Alert Messages
        func displayAlertMessage(userMessage:String)
        {
            let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
            
            myAlert.addAction(okAction);
            
            self.present(myAlert, animated: true, completion:nil)
        }
        

        //creating the post parameter by concatenating the keys and values from text field
        let postParameters = "email="+email!+"&password="+password!;
        
        //adding the parameters to request body
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil{
                print("error is \(error)")
                return;
            }
            //parsing the response
            do {
                //converting resonse to NSDictionary
                let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                //parsing the json
                if let parseJSON = myJSON {
                    
                    //creating a string
                    var msg : String!
                    
                    //getting the json response
                    msg = parseJSON["message"] as! String?
                    
                    //printing the response
                    print(msg)
                    
                }
            } catch {
                print(error)
            }
            
            self.e = self.emailTextField.text!
            
            
        }
        //executing the task
        task.resume()
        

        
        
        UserDefaults.standard.set(emailTextField.text, forKey: "e")
            
        }
    
    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

        // Do any additional setup after loading the view.
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLoginProcess" {
            if let destination = segue.destination as? MyCardViewController {
                destination.id = self.id
                destination.firstName = self.name
            }
        }
    }
    
    
    
}
