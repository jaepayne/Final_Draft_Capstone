//
//  RolodexViewController.swift
//  Digidex iOS - Main File
//
//  Created by Jimmy  Payne on 4/20/17.
//  Copyright © 2017 Digidex iOS. All rights reserved.
//

import UIKit

class RolodexViewController: UIViewController {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var cardImage: UIImageView!
    @IBAction func deleteBTN(_ sender: Any) {
    }
    @IBAction func favoriteBTN(_ sender: Any) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Getting
        
        let defaults = UserDefaults.standard
        let picture = defaults.string(forKey: "QR Code")
        
        if picture != nil {
            
        
        
        let imageURL = URL(string: picture!)!
        
        // communicate back user as main queue
        DispatchQueue.main.async(execute: {
            
            // get data from image url
            let imageData = try? Data(contentsOf: imageURL)
            
            // if data is not nill assign it to ava.Img
            if imageData != nil {
                DispatchQueue.main.async(execute: {
                    self.cardImage.image = UIImage(data: imageData!)
                })
            }
        })
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
