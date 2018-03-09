//
//  MyCardViewController.swift
//  Digidex iOS - Main File
//
//  Created by Michael Schafer on 2/21/17.
//  Copyright © 2017 Digidex iOS. All rights reserved.
//

import UIKit

class MyCardViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            my_card.image = image
            
        } else {
            
            print("There was a problem getting the image")
        }
        
    }
    
    @IBAction func upload(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        imagePickerController.allowsEditing = false
        
        self.present(imagePickerController, animated: true, completion: nil)
        
        //Start
        
    
    //End
    
        
    }
    
    @IBAction func take_photo(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        
        imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
        
        imagePickerController.allowsEditing = false
        
        self.present(imagePickerController, animated: true, completion: nil)
        
    }

    
    //Leaving this here just in case
    var id = ""
    var firstName = ""
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createBodyWithParams(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundry: String) -> NSData {
        
        let body = NSMutableData();
        
        if parameters != nil {
            for(key, value) in parameters! {
            body.appendString(string: "--\(boundry)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(value)\r\n")
        }
        
    }
    
    let filename = "ava.jpg"
        
    let mimetype = "image/jpg"
        
    body.appendString(string: "--\(boundry)\r\n")
    body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
    body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
    body.append(imageDataKey as Data)
    body.appendString(string: "\r\n")
        
    body.appendString(string: "--\(boundry)--\r\n")
        
    return body
    
    }
    
    //upload image to server
    func uploadAva() {
        
        // shotcut id
        let id = user!["id"] as! String
        
        // url path to php file
        let url = URL(string: "https://cgi.soic.indiana.edu/~team62/Capstone/uploadAva.php")!
        
        // declare request to this file
        let request = NSMutableURLRequest(url: url)
        
        // declare method of passign inf to this file
        request.httpMethod = "POST"
        
        // param to be sent in body of request
        let param = ["id" : id]
        
        // body
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // compress image and assign to imageData var
        let imageData = UIImageJPEGRepresentation(my_card.image!, 0.5)
        
        // if not compressed, return ... do not continue to code
        if imageData == nil {
            return
        }
        
        // ... body
        request.httpBody = createBodyWithParams(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundry: boundary) as Data
        
        
        // launc session
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:Error?) in
            
            // get main queue to communicate back to user
            DispatchQueue.main.async(execute: {
                
                if error == nil {
                    
                    do {
                        // json containes $returnArray from php
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        
                        // declare new parseJSON to store json
                        guard let parseJSON = json else {
                            print("Error while parsing")
                            return
                        }
                        
                        // get id from $returnArray["id"] - parseJSON["id"]
                        let id = parseJSON["id"]
                        
                        // successfully uploaded
                        if id != nil {
                            
                            // save user information we received from our host
                            UserDefaults.standard.set(parseJSON, forKey: "parseJSON")
                            user = UserDefaults.standard.value(forKey: "parseJSON") as? NSDictionary
                            
                            // did not give back "id" value from server
                        } else {
                            
                            
                            
                        }
                        
                        // error while jsoning
                    } catch {
                        
                        // get main queue to communicate back to user
                        DispatchQueue.main.async(execute: {
                            let message = error as! String
                            createAlert(title: "Error", message: message)
                        })
                        
                    }
                    
                    // error with php
                } else {
                    
                    // get main queue to communicate back to user
                    DispatchQueue.main.async(execute: {
                        let message = error!.localizedDescription
                        createAlert(title: "Error", message: message)
                    })
                    
                }
                
                
            })
            
        }) .resume()
        
        
    }


}

extension NSMutableData {
    
    func appendString(string: String) {
        
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
