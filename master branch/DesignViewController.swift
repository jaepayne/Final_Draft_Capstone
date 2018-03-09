//
//  DesignViewController.swift
//  Digidex iOS - Main File
//
//  Created by Jimmy  Payne on 4/19/17.
//  Copyright © 2017 Digidex iOS. All rights reserved.
//

import UIKit
import CoreData

class DesignViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let colorArray = ["Black", "White", "Gray", "Blue", "Green", "Orange", "Red", "Turquoise"]
    let templateArray = ["None", "Triangle", "Square", "Star"]
    var buttonSelected = ""
    var isBold = false; var isItalicized = false
    
    // need to add the UIView still but waiting to make the nib
    @IBOutlet weak var userCardView: userCard!
    
    //Button's and their labels on the main view
    @IBAction func colorBTN(_ sender: Any) {
        pickerPopUpView.isHidden = false; templatePicker.isHidden = true; colorPicker.isHidden = false
        buttonSelected = "textColor"
        disableOtherButtons(currentButton: buttonSelected)
        colorButton.layer.borderColor = UIColor(colorLiteralRed: 1, green: 0.2745, blue: 0.3529, alpha: 1).cgColor
        colorButton.backgroundColor = UIColor.clear
    }
    @IBAction func boldBTN(_ sender: Any) {
        if isBold {
            boldButton.backgroundColor = UIColor(colorLiteralRed: 1, green: 0.2745, blue: 0.3529, alpha: 1)
            isBold = false
            UserDefaults.standard.set(isBold, forKey: "bold")
            userCardView.awakeFromNib()
            
        } else {
            
            boldButton.backgroundColor = UIColor.clear
            isBold = true
            UserDefaults.standard.set(isBold, forKey: "bold")
            userCardView.awakeFromNib()
        
        }
        
    }
    @IBAction func italicsBTN(_ sender: Any) {
        if isItalicized {
            italicsButton.backgroundColor = UIColor(colorLiteralRed: 1, green: 0.2745, blue: 0.3529, alpha: 1)
            isItalicized = false
            UserDefaults.standard.set(isItalicized, forKey: "italics")
            userCardView.awakeFromNib()
            
        } else {
            
            italicsButton.backgroundColor = UIColor.clear
            isItalicized = true
            UserDefaults.standard.set(isItalicized, forKey: "italics")
            userCardView.awakeFromNib()
           
        }
    }
    @IBAction func selectTemplateBTN(_ sender: Any) {
        pickerPopUpView.isHidden = false; templatePicker.isHidden = false; colorPicker.isHidden = true
        buttonSelected = "selectTemplate"
        disableOtherButtons(currentButton: buttonSelected)
        selectTemplateButton.layer.borderColor = UIColor(colorLiteralRed: 1, green: 0.2745, blue: 0.3529, alpha: 1).cgColor
        selectTemplateButton.backgroundColor = UIColor.clear
    }
    @IBAction func templateColorBTN(_ sender: Any) {
        pickerPopUpView.isHidden = false; templatePicker.isHidden = true; colorPicker.isHidden = false
        buttonSelected = "templateColor"
        disableOtherButtons(currentButton: buttonSelected)
        templateColorButton.layer.borderColor = UIColor(colorLiteralRed: 1, green: 0.2745, blue: 0.3529, alpha: 1).cgColor
        templateColorButton.backgroundColor = UIColor.clear

    }
    @IBAction func backgroundColorBTN(_ sender: Any) {
        pickerPopUpView.isHidden = false; templatePicker.isHidden = true; colorPicker.isHidden = false
        buttonSelected = "backgroundColor"
        disableOtherButtons(currentButton: buttonSelected)
        templateColorButton.layer.borderColor = UIColor(colorLiteralRed: 1, green: 0.2745, blue: 0.3529, alpha: 1).cgColor
        templateColorButton.backgroundColor = UIColor.clear
    }
    @IBAction func clearCardBTN(_ sender: Any) {
        noButton.isHidden = false; yesButton.isHidden = false
    }
    @IBAction func yesBTN(_ sender: Any) {
        resetButton()
        noButton.isHidden = true; yesButton.isHidden = true
    }
    @IBAction func noBTN(_ sender: Any) {
        noButton.isHidden = true; yesButton.isHidden = true
    }
    
    
    //Labels 
    @IBOutlet weak var textOptionsLBL: UILabel!
    @IBOutlet weak var cardOptionsLBL: UILabel!
        //button labels
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var boldButton: UIButton!
    @IBOutlet weak var italicsButton: UIButton!
    @IBOutlet weak var selectTemplateButton: UIButton!
    @IBOutlet weak var templateColorButton: UIButton!
    @IBOutlet weak var backgroundColorButton: UIButton!
    @IBOutlet weak var clearCardButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    // navigation bar 
    @IBOutlet weak var designNavBar: UIToolbar!
    @IBOutlet weak var yourCardButton: UIBarButtonItem!
    @IBOutlet weak var userInfoButton: UIBarButtonItem!
    @IBAction func yourCardBTN(_ sender: Any) {
    }
    @IBAction func userInfoBTN(_ sender: Any) {
    }
    @IBAction func saveBTN(_ sender: UIBarButtonItem) {
        screenShot()
    }
    
    func screenShot () {
        UIGraphicsBeginImageContext(userCardView.frame.size)
        userCardView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let cardImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(cardImage!, nil, nil, nil)
        
        let imgData = UIImagePNGRepresentation(cardImage!)
        UserDefaults.standard.set(imgData, forKey: "userCardImage")

        
        
        //alerts the user that their card has been saved
        let alert = UIAlertController(title: "Saved", message: "Your card has been saved to photos", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // pickerView 
    @IBOutlet weak var pickerPopUpView: UIView!
    @IBOutlet weak var templatePicker: UIPickerView!
    @IBOutlet weak var colorPicker: UIPickerView!
    @IBOutlet weak var doneButton: UIButton!
    @IBAction func doneBTN(_ sender: Any) {
        pickerPopUpView.isHidden = true; templatePicker.isHidden = true; colorPicker.isHidden = true
        buttonSelected = ""
        enableAllButtons(currentButton: buttonSelected)
        
        let buttonArray = [colorButton, backgroundColorButton, selectTemplateButton, templateColorButton, ]
        for button in buttonArray {
            changeDesign(objectChanged: button!)
        }

    }
    
    // user created functions:
    
    func disableOtherButtons (currentButton: String) {
        if currentButton != "" {
            colorButton.isUserInteractionEnabled = false
            templateColorButton.isUserInteractionEnabled = false
            selectTemplateButton.isUserInteractionEnabled = false
            backgroundColorButton.isUserInteractionEnabled = false
            clearCardButton.isUserInteractionEnabled = false
            boldButton.isUserInteractionEnabled = false
            italicsButton.isUserInteractionEnabled = false
        }
    }
    func enableAllButtons (currentButton: String) {
        if currentButton == "" {
            colorButton.isUserInteractionEnabled = true
            templateColorButton.isUserInteractionEnabled = true
            selectTemplateButton.isUserInteractionEnabled = true
            backgroundColorButton.isUserInteractionEnabled = true
            clearCardButton.isUserInteractionEnabled = true
            boldButton.isUserInteractionEnabled = true
            italicsButton.isUserInteractionEnabled = true
        }
    }
    func changeDesign(objectChanged: AnyObject) {
        objectChanged.layer.cornerRadius = 5.0
        objectChanged.layer.shadowOpacity = 0.2
        objectChanged.layer.shadowRadius = 0.5
        objectChanged.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        objectChanged.layer.borderWidth = 2
        objectChanged.layer.borderColor = UIColor(colorLiteralRed: 1, green: 0.2745, blue: 0.3529, alpha: 1).cgColor
        objectChanged.layer.backgroundColor = UIColor(colorLiteralRed: 1, green: 0.2745, blue: 0.3529, alpha: 1).cgColor
    }
    
    func resetButton () {
        UserDefaults.standard.setValue("White", forKey: "backgroundColor")
        UserDefaults.standard.setValue("Black", forKey: "textColor")
        UserDefaults.standard.setValue("None", forKey: "templateImage")
        buttonSelected = ""
        UserDefaults.standard.set(100.0, forKey: "xName")
        UserDefaults.standard.set(20.0, forKey: "yName")
        
        UserDefaults.standard.set(100.0, forKey: "xEmail")
        UserDefaults.standard.set(45.0, forKey: "yEmail")
        
        UserDefaults.standard.set(100.0, forKey: "xPhone")
        UserDefaults.standard.set(70.0, forKey: "yPhone")
        
        UserDefaults.standard.set(100.0, forKey: "xJob")
        UserDefaults.standard.set(95.0, forKey: "yJob")
        
        UserDefaults.standard.set(100.0, forKey: "xOrganization")
        UserDefaults.standard.set(120.0, forKey: "yOrganization")
        
        UserDefaults.standard.set(100.0, forKey: "xWebsite")
        UserDefaults.standard.set(145.0, forKey: "yWebsite")
        
        UserDefaults.standard.set(false, forKey: "bold")
        UserDefaults.standard.set(false, forKey: "italics")
        userCardView.awakeFromNib()
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerPopUpView.isHidden = true
        noButton.isHidden = true; yesButton.isHidden = true

        let buttonArray = [colorButton, boldButton, italicsButton, selectTemplateButton, templateColorButton, backgroundColorButton, clearCardButton, yesButton, noButton]
        for button in buttonArray {
            button?.layer.cornerRadius = 5.0
            button?.layer.shadowOpacity = 0.2
            button?.layer.shadowRadius = 0.5
            button?.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
            button?.layer.borderWidth = 2
            button?.layer.borderColor = UIColor(colorLiteralRed: 1, green: 0.2745, blue: 0.3529, alpha: 1).cgColor
            button?.layer.backgroundColor = UIColor(colorLiteralRed: 1, green: 0.2745, blue: 0.3529, alpha: 1).cgColor
        }
        userCardView.awakeFromNib()
    }

    override func viewDidAppear(_ animated: Bool) {
        userCardView.awakeFromNib()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == templatePicker {
            return templateArray.count
        } else {
            return colorArray.count
        }
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == templatePicker {
            return templateArray[row]
        } else {
            return colorArray[row]
        }
        
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if pickerView == templatePicker {
            if templateArray[row] == "None" {
                UserDefaults.standard.set("None", forKey: "templateSelection")
                userCardView.awakeFromNib()
            }
            if templateArray[row] == "Triangle" {
                UserDefaults.standard.set("Triangle", forKey: "templateSelection")
                userCardView.awakeFromNib()
            }
            if templateArray[row] == "Square" {
                UserDefaults.standard.set("Square", forKey: "templateSelection")
                userCardView.awakeFromNib()
            }
            if templateArray[row] == "Star" {
                UserDefaults.standard.set("Star", forKey: "templateSelection")
                userCardView.awakeFromNib()
            }
        } else {
            print("Color Picker")
            print(buttonSelected)
            if buttonSelected == "textColor" {
                if colorArray[row] == "Black" {
                    UserDefaults.standard.setValue("Black", forKey: "textColor"); userCardView.awakeFromNib()}
                if colorArray[row] == "White" {
                    UserDefaults.standard.setValue("White", forKey: "textColor"); userCardView.awakeFromNib()}
                if colorArray[row] == "Gray" {
                    UserDefaults.standard.setValue("Gray", forKey: "textColor"); userCardView.awakeFromNib()}
                if colorArray[row] == "Blue" {
                    UserDefaults.standard.setValue("Blue", forKey: "textColor"); userCardView.awakeFromNib()}
                if colorArray[row] == "Green" {
                    UserDefaults.standard.setValue("Green", forKey: "textColor"); userCardView.awakeFromNib()}
                if colorArray[row] == "Orange" {
                    UserDefaults.standard.setValue("Orange", forKey: "textColor"); userCardView.awakeFromNib()}
                if colorArray[row] == "Red" {
                    UserDefaults.standard.setValue("Red", forKey: "textColor"); userCardView.awakeFromNib()}
                if colorArray[row] == "Turquoise" {
                    UserDefaults.standard.setValue("Turquoise", forKey: "textColor"); userCardView.awakeFromNib()}
            }
            if buttonSelected == "backgroundColor" {
                if colorArray[row] == "Black" {
                    UserDefaults.standard.setValue("Black", forKey: "backgroundColor"); userCardView.awakeFromNib()}
                if colorArray[row] == "White" {
                    UserDefaults.standard.setValue("White", forKey: "backgroundColor"); userCardView.awakeFromNib()}
                if colorArray[row] == "Gray" {
                    UserDefaults.standard.setValue("Gray", forKey: "backgroundColor"); userCardView.awakeFromNib()}
                if colorArray[row] == "Blue" {
                    UserDefaults.standard.set("Blue", forKey: "backgroundColor"); userCardView.awakeFromNib()}
                if colorArray[row] == "Green" {
                    UserDefaults.standard.setValue("Green", forKey: "backgroundColor"); userCardView.awakeFromNib()}
                if colorArray[row] == "Orange" {
                    UserDefaults.standard.setValue("Orange", forKey: "backgroundColor"); userCardView.awakeFromNib()}
                if colorArray[row] == "Red" {
                    UserDefaults.standard.setValue("Red", forKey: "backgroundColor"); userCardView.awakeFromNib()}
                if colorArray[row] == "Turquoise" {
                    UserDefaults.standard.setValue("Turquoise", forKey: "backgroundColor"); userCardView.awakeFromNib()}
                
            }// button selected
            if buttonSelected == "templateColor" {
                if colorArray[row] == "Black" {
                    UserDefaults.standard.set("Black", forKey: "templateColor"); userCardView.awakeFromNib()}
                if colorArray[row] == "White" {
                    UserDefaults.standard.set("White", forKey: "templateColor"); userCardView.awakeFromNib()}
                if colorArray[row] == "Gray" {
                    UserDefaults.standard.set("Gray", forKey: "templateColor"); userCardView.awakeFromNib()}
                if colorArray[row] == "Blue" {
                    UserDefaults.standard.set("Blue", forKey: "templateColor"); userCardView.awakeFromNib()}
                if colorArray[row] == "Green" {
                    UserDefaults.standard.setValue("Green", forKey: "templateColor"); userCardView.awakeFromNib()}
                if colorArray[row] == "Orange" {
                    UserDefaults.standard.setValue("Orange", forKey: "templateColor"); userCardView.awakeFromNib()}
                if colorArray[row] == "Red" {
                    UserDefaults.standard.setValue("Red", forKey: "templateColor"); userCardView.awakeFromNib()}
                if colorArray[row] == "Turquoise" {
                    UserDefaults.standard.setValue("Turquoise", forKey: "templateColor"); userCardView.awakeFromNib()}
            }
        }
    }


    
}
