//
//  QRCodeViewController.swift
//  Digidex iOS - Main File
//
//  Created by Michael Schafer on 2/21/17.
//  Copyright © 2017 Digidex iOS. All rights reserved.
//

import UIKit
import QRCode


class QRCodeViewController: UIViewController {
    
    @IBOutlet var qr_image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ava = user?["ava"] as? String

        qr_image.image = {
            var qrCode = QRCode("\(ava!)")!
            qrCode.size = self.qr_image.bounds.size
            qrCode.errorCorrection = .High
            return qrCode.image
        }()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
