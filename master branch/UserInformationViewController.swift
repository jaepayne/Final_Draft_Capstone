//
//  UserInformationViewController.swift
//  Digidex iOS - Main File
//
//  Created by Jimmy  Payne on 4/19/17.
//  Copyright © 2017 Digidex iOS. All rights reserved.
//

import UIKit

class UserInformationViewController: UIViewController {
    
    let URL_SAVE_TEAM = "https://cgi.soic.indiana.edu/~team62/user_info_insert.php"
    
    //Defining the text field variable connections
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var jobTitleTF: UITextField!
    @IBOutlet weak var organizationNameTF: UITextField!
    @IBOutlet weak var websiteTF: UITextField!
    
    //making the buttons 
    
    @IBAction func saveBTN(_ sender: Any) {
        let textFieldArray = [firstNameTF.text, lastNameTF.text, emailTF.text, phoneNumberTF.text, jobTitleTF.text, organizationNameTF.text, websiteTF.text]
        var stringArray = [String]()
        for item in textFieldArray {
            stringArray.append(item!)
        }
        UserDefaults.standard.set(stringArray, forKey: "userArray")
        print(stringArray)
    }
    
    func setFields() {
        let name = "\(firstNameTF.text) \(lastNameTF.text)"
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.set(emailTF.text, forKey: "email")
        UserDefaults.standard.set(phoneNumberTF.text, forKey: "phone")
        UserDefaults.standard.set(jobTitleTF.text, forKey: "job")
        UserDefaults.standard.set(organizationNameTF.text, forKey: "organization")
        UserDefaults.standard.set(websiteTF.text, forKey: "website")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let arrayObject = UserDefaults.standard.object(forKey: "userArray"){
            let newArray = arrayObject as! NSArray
            for _ in newArray {
                firstNameTF.text = newArray[0] as? String
                lastNameTF.text = newArray[1] as? String
                emailTF.text = newArray[2] as? String
                phoneNumberTF.text = newArray[3] as? String
                jobTitleTF.text = newArray[4] as? String
                organizationNameTF.text = newArray[5] as? String
                websiteTF.text = newArray[6] as? String
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
