//
//  UploadCardViewController.swift
//  Digidex iOS - Main File
//
//  Created by Michael Schafer on 4/19/17.
//  Copyright © 2017 Digidex iOS. All rights reserved.
//

import UIKit

class UploadCardViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var showQROutlet: UIButton!
    @IBOutlet weak var scanQROutlet: UIButton!
    @IBOutlet weak var takePictureOutlet: UIButton!
    @IBOutlet weak var uplaodCardOutlet: UIButton!
    
    func changeDesign(objectChanged: AnyObject) {
        objectChanged.layer.cornerRadius = 5.0
        objectChanged.layer.shadowOpacity = 0.2
        objectChanged.layer.shadowRadius = 0.5
        objectChanged.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        objectChanged.layer.borderWidth = 2
        objectChanged.layer.borderColor = UIColor(colorLiteralRed: 1, green: 0.2745, blue: 0.3529, alpha: 1).cgColor
        objectChanged.layer.backgroundColor = UIColor(colorLiteralRed: 1, green: 0.2745, blue: 0.3529, alpha: 1).cgColor
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        changeDesign(objectChanged: scanQROutlet)
        changeDesign(objectChanged: showQROutlet)
        changeDesign(objectChanged: uplaodCardOutlet)
        changeDesign(objectChanged: takePictureOutlet)
        //get user details from user global var
     

        let ava = user?["ava"] as? String
        
        
        // get user profile picture
        if ava != "" {
            
            // url path to image
            let imageURL = URL(string: ava!)!
            
            // communicate back user as main queue
            DispatchQueue.main.async(execute: {
                
                // get data from image url
                let imageData = try? Data(contentsOf: imageURL)
                
                // if data is not nill assign it to ava.Img
                if imageData != nil {
                    DispatchQueue.main.async(execute: {
                        self.avaImg.image = UIImage(data: imageData!)
                    })
                }
            })
            
        }
        
    }


    @IBAction func UploadButtonTapped(_ sender: Any) {
        
        //select ava
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func PhotoButtonTapped(_ sender: Any) {
        
        //take photo
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.camera
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
        
    }
    

    
        //select image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        //call upload to server function
        uploadAva()
        
    }
    
    // custom body of HTTP request to upload image file
    func createBodyWithParams(_ parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
        
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename = "ava.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)--\r\n")
        
        return body as Data
        
    }
    
    // upload image to serve
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
        let imageData = UIImageJPEGRepresentation(avaImg.image!, 0.5)
        
        // if not compressed, return ... do not continue to code
        if imageData == nil {
            return
        }
        
        // ... body
        request.httpBody = createBodyWithParams(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
        
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
                            
                            // get main queue to communicate back to user
                            DispatchQueue.main.async(execute: {
                                let message = parseJSON["message"] as! String
                                createAlert(title: "Error", message: message)
                            })
                            
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

func createAlert(title: String, message: String) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
        
        alert.dismiss(animated: true, completion: nil)
        
    }))
    
    alert.present(alert, animated: true, completion: nil)
    
}


// Creating protocol of appending string to var of type data
extension NSMutableData {
    
    func appendString(_ string : String) {
        
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
        
    }
    
}

