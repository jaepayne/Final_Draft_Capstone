//
//  HomePageViewController.swift
//  Digidex iOS - Main File
//
//  Created by Michael Schafer on 4/17/17.
//  Copyright © 2017 Digidex iOS. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginOutlet: UIButton!
    @IBOutlet weak var signupOutlet: UIButton!
    
    //Useful functions
    func changeDesign(objectChanged: AnyObject) {
        objectChanged.layer.cornerRadius = 5.0
        objectChanged.layer.shadowOpacity = 0.2
        objectChanged.layer.shadowRadius = 0.5
        objectChanged.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        objectChanged.layer.borderWidth = 2
        objectChanged.layer.borderColor = UIColor(colorLiteralRed: 1, green: 0.2745, blue: 0.3529, alpha: 1).cgColor
        objectChanged.layer.backgroundColor = UIColor(colorLiteralRed: 1, green: 0.2745, blue: 0.3529, alpha: 1).cgColor
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
    
    //First Function
    

    //Signup Button Tapped
    @IBAction func signupButtonTapped(_ sender: Any) {
        
        //if invalid email or no password
        if isValidEmail(testStr: emailTxt.text!) && passwordTxt.text != "" {
            
            self.performSegue(withIdentifier: "showSignUpProcess", sender: self)
            
            // Create new user in mySQL
            
            //url to php file
            let url = NSURL(string: "https://cgi.soic.indiana.edu/~team62/Capstone/register.php")!
            let request = NSMutableURLRequest(url: url as URL)
            
            //method to pass data to this file
            request.httpMethod = "POST"
            
            //body to be appended to url
            let body = "email=\(emailTxt.text!.lowercased())&password=\(passwordTxt.text!)"
            
            request.httpBody = body.data(using: String.Encoding.utf8)
            //launching
            URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:Error?) in
                
                if error == nil {
                    
                    //communicate back
                    DispatchQueue.main.async(execute: {
                        
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                            
                            guard let parseJSON = json else {
                                print("Error while parsing")
                                return
                            }
                            
                            let id = parseJSON["id"]
            
                            if id != nil {
                                print(parseJSON)
                                
                                UserDefaults.standard.set(parseJSON, forKey: "parseJSON")
                                user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary
                                
                            }
                        } catch {
                            print("Caught an error: \(error)")
                        }
                    })
                } else {
                    print("error: \(error)")
                }
                
                //launch prepared session
            }).resume()
            
            
        } else {
            
            createAlert(title: "Error", message: "Please enter a valid email and password.")
        }
        
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        let email = emailTxt.text!.lowercased()
        let password = passwordTxt.text!
    
        
        let url = NSURL(string: "https://cgi.soic.indiana.edu/~team62/Capstone/login.php")!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        let body = "email=\(email)&password=\(password)"
        
        print(body)
        
        request.httpBody = body.data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:Error?) in
            
            if error == nil {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                    guard let parseJSON = json else {
                        print("Error while parsing")
                        return
                    }
                    
                    print(parseJSON)
                    
                    let id = parseJSON["id"] as? String
                    
                    if id != nil {
                        
                        //save user information we recieve from our host
                        UserDefaults.standard.set(parseJSON, forKey: "parseJSON")
                        user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary
                        
                        //successfully logged in
                        
                        OperationQueue.main.addOperation {
                            self.performSegue(withIdentifier: "showLoginProcess", sender: self)
                        }
                        
                    } else {
                        OperationQueue.main.addOperation{
                        self.emailTxt.text = ""
                        self.passwordTxt.text = ""
                        
                        self.createAlert(title: "Error", message: "Username or password incorrect.")
                        }
                        
                    }
                    
                
                } catch {
                    print("Caught an error: \(error)")
                }
                
            } else {
                print("Error: \(error)")
            }
            
            
        }).resume()
        
        print(user?["id"])
        
        
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeDesign(objectChanged: loginOutlet)
        changeDesign(objectChanged: signupOutlet)
        
        //Step 1
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    //Step 2
    func didTapView(gesture: UITapGestureRecognizer){
        view.endEditing(true)
    }
    //Step 3
    func addObservers() {
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil){
            notification in
            self.keyboardWillShow(notification: notification)
        }
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil){
            notification in
            self.keyboardWillHide(notification: notification)
        }
    }
    //Step 6
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    //Step 4
    func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        scrollView.contentInset = contentInset
    }
    //Step 5
    func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
    }
    }









