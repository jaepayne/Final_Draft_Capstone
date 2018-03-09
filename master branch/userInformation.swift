//
//  userInformation.swift
//  Digidex iOS - Main File
//
//  Created by Morgan Baker on 2/22/17.
//  Copyright © 2017 Digidex iOS. All rights reserved.
//

import UIKit

class userInformation: UIViewController, UITextFieldDelegate {
    
    let URL_SAVE_TEAM = "https://cgi.soic.indiana.edu/~team62/user_info_insert.php"
    
    
    // these three just added ----> you may need to add them down the line
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var organization: UITextField!
    @IBOutlet weak var job: UITextField!
    @IBOutlet weak var website: UITextField!
    @IBOutlet weak var phoneNumberTwo: UITextField!
    @IBOutlet weak var emailNumberTwo: UITextField!
    
    @IBOutlet var email_label: UILabel!

    
    @IBAction func saveButtonTapped(_ sender: AnyObject) {
        
        //created NSURL
        let requestURL = NSURL(string: URL_SAVE_TEAM)
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        //getting values from text fields
        let email = self.email.text
        let password = self.password.text
        let firstName = self.firstName.text
        let lastName = self.lastName.text
        let phoneNumber = self.phoneNumber.text
        let organization = self.organization.text
        let job = self.job.text
        let website = self.website.text
        let phoneNumberTwo = self.phoneNumberTwo.text
        let emailNumberTwo = self.emailNumberTwo.text
        
        //Display Alert Messages
        func displayAlertMessage(userMessage:String)
        {
            let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
            
            myAlert.addAction(okAction);
            
            self.present(myAlert, animated: true, completion:nil)
        }
        
        //If all the required fields are not filled out create an error message to the user
        
        if(firstName!.isEmpty || lastName!.isEmpty)
        {
            displayAlertMessage(userMessage: "All fields are required fields to fill in")
            return
        }

        //creating the post parameter by concatenating the keys and values from text field
        let postParameters = "email="+email!+"&password="+password!+"&firstName="+firstName!+"&lastName="+lastName!+"&phoneNumber="+phoneNumber!+"&organization="+organization!+"&job="+job!+"&website="+website!+"&phoneNumberTwo="+phoneNumberTwo!+"&emailNumberTwo="+emailNumberTwo!;
        
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
            
        }
        //executing the task
        task.resume()

        
       
 
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTextFields()
        
        let fnameObject = UserDefaults.standard.object(forKey: "fname")
        if let fname = fnameObject as? String {
            firstName.text = fname
        }
        let lnameObject = UserDefaults.standard.object(forKey: "lname")
        if let lname = lnameObject as? String {
            lastName.text = lname
        }
        let contactObject = UserDefaults.standard.object(forKey: "contact")
        if let contact = contactObject as? String {
            phoneNumber.text = contact
        }
        let orgObject = UserDefaults.standard.object(forKey: "org")
        if let org = orgObject as? String {
            organization.text = org
        }
        let jobObject = UserDefaults.standard.object(forKey: "jobTitle")
        if let jobTitle = jobObject as? String {
            job.text = jobTitle
        }
        let webObject = UserDefaults.standard.object(forKey: "web")
        if let web = webObject as? String {
            website.text = web
        }
        let contact2Object = UserDefaults.standard.object(forKey: "contact2")
        if let contact2 = contact2Object as? String {
            phoneNumberTwo.text = contact2
        }
        let email2Object = UserDefaults.standard.object(forKey: "email2")
        if let email2 = email2Object as? String {
            emailNumberTwo.text = email2
        }


        // Do any additional setup after loading the view.
    }
    
    
    
    
    // Designate this class as the text fields' delegate
    // and set their keyboards while we're at it.
    func initializeTextFields() {
        firstName.delegate = self
        firstName.keyboardType = UIKeyboardType.asciiCapable
        
        lastName.delegate = self
        lastName.keyboardType = UIKeyboardType.asciiCapable
        
        phoneNumber.delegate = self
        phoneNumber.keyboardType = UIKeyboardType.asciiCapable
        
        organization.delegate = self
        organization.keyboardType = UIKeyboardType.asciiCapable
        
        job.delegate = self
        job.keyboardType = UIKeyboardType.asciiCapable
        
        website.delegate = self
        website.keyboardType = UIKeyboardType.asciiCapable
        
        phoneNumberTwo.delegate = self
        phoneNumberTwo.keyboardType = UIKeyboardType.asciiCapable
        
        emailNumberTwo.delegate = self
        emailNumberTwo.keyboardType = UIKeyboardType.asciiCapable
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Tap outside a text field to dismiss the keyboard
    // ------------------------------------------------
    // By changing the underlying class of the view from UIView to UIControl,
    // the view can respond to events, including Touch Down, which is
    // wired to this method.
    @IBAction func userTappedBackground(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    
    // MARK: UITextFieldDelegate events and related methods
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String)
        -> Bool
    {
        // We ignore any change that doesn't add characters to the text field.
        // These changes are things like character deletions and cuts, as well
        // as moving the insertion point.
        //
        // We still return true to allow the change to take place.
        if string.characters.count == 0 {
            return true
        }
        
        // Check to see if the text field's contents still fit the constraints
        // with the new content added to it.
        // If the contents still fit the constraints, allow the change
        // by returning true; otherwise disallow the change by returning false.
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        switch textField {
            
            // Allow only upper- and lower-case vowels in this field,
        // and limit its contents to a maximum of 6 characters.
        case firstName:
            return prospectiveText.doesNotContainCharactersIn(";") &&
                prospectiveText.characters.count <= 25
            
            // Allow any characters EXCEPT upper- and lower-case vowels in this field,
        // and limit its contents to a maximum of 8 characters.
        case lastName:
            return prospectiveText.doesNotContainCharactersIn(";") &&
                prospectiveText.characters.count <= 25
            
            // Allow only digits in this field,
        // and limit its contents to a maximum of 3 characters.
        case phoneNumber:
            return prospectiveText.containsOnlyCharactersIn("0123456789") &&
                prospectiveText.characters.count <= 10
            
        case organization:
            return prospectiveText.doesNotContainCharactersIn(";") &&
                prospectiveText.characters.count <= 25
        
        case job:
            return prospectiveText.doesNotContainCharactersIn(";") &&
                prospectiveText.characters.count <= 25
            
        case website:
            return prospectiveText.doesNotContainCharactersIn(";") &&
                prospectiveText.characters.count <= 25
            
        case phoneNumberTwo:
            return prospectiveText.containsOnlyCharactersIn("0123456789") &&
                prospectiveText.characters.count <= 10
            
        case emailNumberTwo:
            return prospectiveText.doesNotContainCharactersIn(";") &&
                prospectiveText.characters.count <= 25

        // that uses this class as its delegate.
        default:
            return true
        }
        
    }
    
    // Dismiss the keyboard when the user taps the "Return" key or its equivalent
    // while editing a text field.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
}
