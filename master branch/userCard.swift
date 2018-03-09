//
//  userCard.swift
//  Digidex iOS - Main File
//
//  Created by Jimmy  Payne on 4/19/17.
//  Copyright © 2017 Digidex iOS. All rights reserved.
//

import UIKit

class userCard: UIView {
    
    @IBOutlet var userCardView: UIView!
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var emailLBL: UILabel!
    @IBOutlet weak var phoneLBL: UILabel!
    @IBOutlet weak var jobTitleLBL: UILabel!
    @IBOutlet weak var organizationLBL: UILabel!
    @IBOutlet weak var websiteLBL: UILabel!
    @IBOutlet weak var templateImage: UIImageView!
    
    let colorArray = ["Black", "White", "Gray", "Blue", "Green", "Orange", "Red", "Turquoise"]
    let templateArray = ["None", "Triangle", "Square", "Star"]
    var templateSelected = ""
    var redColor = UIColor(colorLiteralRed: 1, green: 0.3922, blue: 0.3922, alpha: 1)
    var greenColor = UIColor(colorLiteralRed: 0.2353, green: 0.4314, blue: 0.2353, alpha: 1)
    var blueColor = UIColor(colorLiteralRed:  0.3529, green: 0.5098, blue: 0.7843, alpha: 1)
    var orangeColor = UIColor(colorLiteralRed: 0.7843, green: 0.5098, blue: 0.3529, alpha: 1)
    var turquoiseColor = UIColor(colorLiteralRed: 0.3961, green: 0.8118, blue: 0.7961, alpha: 1)
    
    var bold = false; var italics = false
    
    func formatLabels() {
        let labelArray: [UILabel] = [nameLBL, emailLBL, phoneLBL, jobTitleLBL, organizationLBL, websiteLBL]
        for items in labelArray {
            let labelSize = CGSize(width:  CGFloat((items.text?.characters.count)! * 11), height: CGFloat(20.0))
            items.frame.size = labelSize
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userCardView.clipsToBounds = true
        let labelIndex: [UILabel] = [nameLBL, emailLBL, phoneLBL, jobTitleLBL, organizationLBL, websiteLBL]
        for label in labelIndex {
            templateImage.bringSubview(toFront: label)
        }
        userCardView.sendSubview(toBack: templateImage)
        
        let textColorObject = UserDefaults.standard.object(forKey: "textColor") as? String
        let backgroundColorObject = UserDefaults.standard.object(forKey: "backgroundColor") as? String
        let templateObject = UserDefaults.standard.object(forKey: "templateSelection") as? String
        let templateColorObject = UserDefaults.standard.object(forKey: "templateColor") as? String
        
        if let boldObject = UserDefaults.standard.object(forKey: "bold") {
            bold = boldObject as! Bool
            
        }
        
        if let italicsObject = UserDefaults.standard.object(forKey: "italics") {
            italics = italicsObject as! Bool
        }
        
        for label in labelIndex {
            if bold == true && italics == true{
                label.font = UIFont(name: "Arial-BoldItalicMT", size: 15)
            } else if bold == false && italics == true{
                label.font = UIFont.italicSystemFont(ofSize: 15)
            } else if bold == true && italics == false{
                label.font = UIFont.boldSystemFont(ofSize: 15)
            } else if bold == false && italics == false{
                label.font = UIFont.systemFont(ofSize: 15)
            }
        }
        
        
        // setting the labels to equal the user information
        if let arrayObject = UserDefaults.standard.object(forKey: "userArray"){
            let newArray = arrayObject as! NSArray
            for _ in newArray {
                let firstName = newArray[0] as! String; let lastName = newArray[1] as! String
                let fullname = "\(firstName) \(lastName)"
                nameLBL.text = fullname as String
                emailLBL.text = newArray[2] as? String
                phoneLBL.text = newArray[3] as? String
                jobTitleLBL.text = newArray[4] as? String
                organizationLBL.text = newArray[5] as? String
                websiteLBL.text = newArray[6] as? String
            }
        }
        for label in labelIndex{
            if label.text == "" {
                label.isHidden = true
            } else {
                label.isHidden = false
            }
        }
        
        formatLabels()
        
        for _ in templateArray {
            if templateObject == templateArray[1] {templateImage.image = UIImage(named: "triangle_black.png"); templateSelected = "Triangle"}
            else if templateObject == templateArray[2]{templateImage.image = UIImage(named: "square_black.png"); templateSelected = "Square"}
            else if templateObject == templateArray[3]{templateImage.image = UIImage(named: "star_black.png"); templateSelected = "Star"}
            else{templateImage.image = nil; templateSelected = ""}
            
            for label in labelIndex {
                templateImage.bringSubview(toFront: label)
            }
        }
        for _ in colorArray {
            if templateSelected == "Triangle" {
                if templateColorObject == colorArray[0] {templateImage.image = UIImage(named: "triangle_black.png")}
                if templateColorObject == colorArray[1] {templateImage.image = UIImage(named: "triangle_white.png")}
                if templateColorObject == colorArray[2] {templateImage.image = UIImage(named: "triangle_gray.png")}
                if templateColorObject == colorArray[3] {templateImage.image = UIImage(named: "triangle_blue.png")}
                if templateColorObject == colorArray[4] {templateImage.image = UIImage(named: "triangle_green.png")}
                if templateColorObject == colorArray[5] {templateImage.image = UIImage(named: "triangle_orange.png")}
                if templateColorObject == colorArray[6] {templateImage.image = UIImage(named: "triangle_red.png")}
                if templateColorObject == colorArray[7] {templateImage.image = UIImage(named: "triangle_turquoise.png")}
            }
            if templateSelected == "Square" {
                if templateColorObject == colorArray[0] {templateImage.image = UIImage(named: "square_black.png")}
                if templateColorObject == colorArray[1] {templateImage.image = UIImage(named: "square_white.png")}
                if templateColorObject == colorArray[2] {templateImage.image = UIImage(named: "square_gray.png")}
                if templateColorObject == colorArray[3] {templateImage.image = UIImage(named: "square_blue.png")}
                if templateColorObject == colorArray[4] {templateImage.image = UIImage(named: "square_green.png")}
                if templateColorObject == colorArray[5] {templateImage.image = UIImage(named: "square_orange.png")}
                if templateColorObject == colorArray[6] {templateImage.image = UIImage(named: "square_red.png")}
                if templateColorObject == colorArray[7] {templateImage.image = UIImage(named: "square_turquoise.png")}
            }
            if templateSelected == "Star" {
                if templateColorObject == colorArray[0] {templateImage.image = UIImage(named: "star_black.png")}
                if templateColorObject == colorArray[1] {templateImage.image = UIImage(named: "star_white.png")}
                if templateColorObject == colorArray[2] {templateImage.image = UIImage(named: "star_gray.png")}
                if templateColorObject == colorArray[3] {templateImage.image = UIImage(named: "star_blue.png")}
                if templateColorObject == colorArray[4] {templateImage.image = UIImage(named: "star_green.png")}
                if templateColorObject == colorArray[5] {templateImage.image = UIImage(named: "star_orange.png")}
                if templateColorObject == colorArray[6] {templateImage.image = UIImage(named: "star_red.png")}
                if templateColorObject == colorArray[7] {templateImage.image = UIImage(named: "star_turquoise.png")}
                
            }
            if templateSelected == "" {templateImage.image = nil}
            for label in labelIndex {
                templateImage.bringSubview(toFront: label)
            }
        }

        
        for _ in colorArray {
            if textColorObject == colorArray[0] {for item in labelIndex {item.textColor = UIColor.black}}
            if textColorObject == colorArray[1] {for item in labelIndex {item.textColor = UIColor.white}}
            if textColorObject == colorArray[2] {for item in labelIndex {item.textColor = UIColor.gray}}
            if textColorObject == colorArray[3] {for item in labelIndex {item.textColor = blueColor}}
            if textColorObject == colorArray[4] {for item in labelIndex {item.textColor = greenColor}}
            if textColorObject == colorArray[5] {for item in labelIndex {item.textColor = orangeColor}}
            if textColorObject == colorArray[6] {for item in labelIndex {item.textColor = redColor}}
            if textColorObject == colorArray[7] {for item in labelIndex {item.textColor = turquoiseColor}}
        }
        for _ in colorArray {
            if backgroundColorObject == colorArray[0] {userCardView.backgroundColor = UIColor.black}
            if backgroundColorObject == colorArray[1] {userCardView.backgroundColor = UIColor.white}
            if backgroundColorObject == colorArray[2] {userCardView.backgroundColor = UIColor.gray}
            if backgroundColorObject == colorArray[3] {userCardView.backgroundColor = blueColor}
            if backgroundColorObject == colorArray[4] {userCardView.backgroundColor = greenColor}
            if backgroundColorObject == colorArray[5] {userCardView.backgroundColor = orangeColor}
            if backgroundColorObject == colorArray[6] {userCardView.backgroundColor = redColor}
            if backgroundColorObject == colorArray[7] {userCardView.backgroundColor = turquoiseColor}
        }
        
        
        // setting the label spot when it loads
        var xNameSpot : CGFloat = nameLBL.center.x; var yNameSpot : CGFloat = nameLBL.center.y
        var xEmailSpot : CGFloat = emailLBL.center.x; var yEmailSpot : CGFloat = emailLBL.center.y
        var xPhoneSpot : CGFloat = phoneLBL.center.x; var yPhoneSpot : CGFloat = phoneLBL.center.y
        var xJobSpot : CGFloat = jobTitleLBL.center.x; var yJobSpot : CGFloat = jobTitleLBL.center.y
        var xOrganizationSpot : CGFloat = organizationLBL.center.x; var yOrganizationSpot : CGFloat = organizationLBL.center.y
        var xWebsiteSpot : CGFloat = websiteLBL.center.x; var yWebsiteSpot : CGFloat = websiteLBL.center.y

        // creating new variables for label positions transferred by user defaults
        //name label
        if let xNamePosition = UserDefaults.standard.object(forKey: "xName"){
            let xName : CGFloat
            xName = xNamePosition as! CGFloat
            xNameSpot = xName
        }
        if let yNamePosition = UserDefaults.standard.object(forKey: "yName"){
            let yName : CGFloat
            yName = yNamePosition as! CGFloat
            yNameSpot = yName
        }
        // email label
        if let xEmailPosition = UserDefaults.standard.object(forKey: "xEmail"){
            let xEmail : CGFloat
            xEmail = xEmailPosition as! CGFloat
            xEmailSpot = xEmail
        }
        if let yEmailPosition = UserDefaults.standard.object(forKey: "yEmail"){
            let yEmail : CGFloat
            yEmail = yEmailPosition as! CGFloat
            yEmailSpot = yEmail
        }
        // phone label
        if let xPhonePosition = UserDefaults.standard.object(forKey: "xPhone"){
            let xPhone : CGFloat
            xPhone = xPhonePosition as! CGFloat
            xPhoneSpot = xPhone
        }
        if let yPhonePosition = UserDefaults.standard.object(forKey: "yPhone"){
            let yPhone : CGFloat
            yPhone = yPhonePosition as! CGFloat
            yPhoneSpot = yPhone
        }
        // Job Title Label
        if let xJobPosition = UserDefaults.standard.object(forKey: "xJob"){
            let xJobTitle : CGFloat
            xJobTitle = xJobPosition as! CGFloat
            xJobSpot = xJobTitle
        }
        if let yJobPosition = UserDefaults.standard.object(forKey: "yJob"){
            let yJobTitle : CGFloat
            yJobTitle = yJobPosition as! CGFloat
            yJobSpot = yJobTitle
        }
        // Organization Label
        if let xOrganizationPosition = UserDefaults.standard.object(forKey: "xOrganization"){
            let xOrganization : CGFloat
            xOrganization = xOrganizationPosition as! CGFloat
            xOrganizationSpot = xOrganization
        }
        if let yOrganizationPosition = UserDefaults.standard.object(forKey: "yOrganization"){
            let yOrganization : CGFloat
            yOrganization = yOrganizationPosition as! CGFloat
            yOrganizationSpot = yOrganization
        }
        if let xWebsitePosition = UserDefaults.standard.object(forKey: "xWebsite"){
            let xWebsite : CGFloat
            xWebsite = xWebsitePosition as! CGFloat
            xWebsiteSpot = xWebsite
        }
        if let yWebsitePosition = UserDefaults.standard.object(forKey: "yWebsite"){
            let yWebsite : CGFloat
            yWebsite = yWebsitePosition as! CGFloat
            yWebsiteSpot = yWebsite
        }

        nameLBL.center = CGPoint(x: xNameSpot, y: yNameSpot)
        print(nameLBL.center)
        emailLBL.center = CGPoint(x: xEmailSpot, y: yEmailSpot)
        print(emailLBL.center)
        phoneLBL.center = CGPoint(x: xPhoneSpot, y: yPhoneSpot)
        print(phoneLBL.center)
        jobTitleLBL.center = CGPoint(x: xJobSpot, y: yJobSpot)
        print(jobTitleLBL.center)
        organizationLBL.center = CGPoint(x: xOrganizationSpot, y: yOrganizationSpot)
        print(organizationLBL.center)
        websiteLBL.center = CGPoint(x: xWebsiteSpot, y: yWebsiteSpot)
        print(websiteLBL.center)
        
        
        //moving the labels around
        let namePan = UIPanGestureRecognizer(target: self, action: #selector(self.namePan(n:)))
        let emailPan = UIPanGestureRecognizer(target: self, action: #selector(self.panEmail(e:)))
        let phonePan = UIPanGestureRecognizer(target: self, action: #selector(self.panPhone(p:)))
        let jobPan = UIPanGestureRecognizer(target: self, action: #selector(self.panJob(j:)))
        let organizationPan = UIPanGestureRecognizer(target: self, action: #selector(self.panOrganization(o:)))
        let websitePan = UIPanGestureRecognizer(target: self, action: #selector(self.panWebsite(w:)))


        
        
        // enabling user interaction for all of the labels
        nameLBL.isUserInteractionEnabled = true
        emailLBL.isUserInteractionEnabled = true
        phoneLBL.isUserInteractionEnabled = true
        jobTitleLBL.isUserInteractionEnabled = true
        organizationLBL.isUserInteractionEnabled = true
        websiteLBL.isUserInteractionEnabled = true
        
        // adding the gesture recognizers to each label
        nameLBL.addGestureRecognizer(namePan)
        emailLBL.addGestureRecognizer(emailPan)
        phoneLBL.addGestureRecognizer(phonePan)
        jobTitleLBL.addGestureRecognizer(jobPan)
        organizationLBL.addGestureRecognizer(organizationPan)
        websiteLBL.addGestureRecognizer(websitePan)
    }
    
    // how you move a single label (must make a seperate function for each label to be moved)
    func namePan(n: UIPanGestureRecognizer)  {
        switch n.state {
        // happens when the pan gesture recognizer begins
        case .began:
            print("began")
            print(nameLBL.center)
            let movingColor = UIColor.yellow
            nameLBL.layer.borderWidth = 1
            nameLBL.layer.borderColor = movingColor.cgColor
        // what moves and places the label in a new position
        case .changed:
            self.nameLBL.center = n.location(in: userCardView)
            print("changed")
        case .ended:
            print("ended")
            print(nameLBL.center)
            nameLBL.layer.borderWidth = 0
            UserDefaults.standard.set(nameLBL.center.x, forKey: "xName")
            UserDefaults.standard.set(nameLBL.center.y, forKey: "yName")
        default:
            print("Default")
        }
    }
    func panEmail(e: UIPanGestureRecognizer)  {
        switch e.state {
        // happens when the pan gesture recognizer begins
        case .began:
            print("began")
            let movingColor = UIColor.yellow
            emailLBL.layer.borderWidth = 1
            emailLBL.layer.borderColor = movingColor.cgColor
        // what moves and places the label in a new position
        case .changed:
            self.emailLBL.center = e.location(in: userCardView)
            print("changed")
        case .ended:
            print("ended")
            emailLBL.layer.borderWidth = 0
            print(emailLBL.center)
            UserDefaults.standard.set(emailLBL.center.x, forKey: "xEmail")
            UserDefaults.standard.set(emailLBL.center.y, forKey: "yEmail")
        default:
            print("Default")
        }
    }
    func panPhone(p: UIPanGestureRecognizer)  {
        switch p.state {
        // happens when the pan gesture recognizer begins
        case .began:
            print("began")
            let movingColor = UIColor.yellow

            phoneLBL.layer.borderWidth = 1
            phoneLBL.layer.borderColor = movingColor.cgColor
        // what moves and places the label in a new position
        case .changed:
            self.phoneLBL.center = p.location(in: userCardView)
            print("changed")
        case .ended:
            print("ended")
            phoneLBL.layer.borderWidth = 0

            print(phoneLBL.center)
            UserDefaults.standard.set(phoneLBL.center.x, forKey: "xPhone")
            UserDefaults.standard.set(phoneLBL.center.y, forKey: "yPhone")
        default:
            print("Default")
        }
    }
    func panJob(j: UIPanGestureRecognizer)  {
        switch j.state {
        // happens when the pan gesture recognizer begins
        case .began:
            print("began")
            let movingColor = UIColor.yellow
            jobTitleLBL.layer.borderWidth = 1
            jobTitleLBL.layer.borderColor = movingColor.cgColor
        // what moves and places the label in a new position
        case .changed:
            self.jobTitleLBL.center = j.location(in: userCardView)
            print("changed")
        case .ended:
            print("ended")
            jobTitleLBL.layer.borderWidth = 0

            print(jobTitleLBL.center)
            UserDefaults.standard.set(jobTitleLBL.center.x, forKey: "xJob")
            UserDefaults.standard.set(jobTitleLBL.center.y, forKey: "yJob")
        default:
            print("Default")
        }
    }
    func panOrganization(o: UIPanGestureRecognizer)  {
        switch o.state {
        // happens when the pan gesture recognizer begins
        case .began:
            print("began")
            let movingColor = UIColor.yellow

            organizationLBL.layer.borderWidth = 1
            organizationLBL.layer.borderColor = movingColor.cgColor
        // what moves and places the label in a new position
        case .changed:
            self.organizationLBL.center = o.location(in: userCardView)
            print("changed")
        case .ended:
            print("ended")
            organizationLBL.layer.borderWidth = 0

            print(organizationLBL.center)
            UserDefaults.standard.set(organizationLBL.center.x, forKey: "xOrganization")
            UserDefaults.standard.set(organizationLBL.center.y, forKey: "yOrganization")
        default:
            print("Default")
        }
    }
    func panWebsite(w: UIPanGestureRecognizer)  {
        switch w.state {
        // happens when the pan gesture recognizer begins
        case .began:
            print("began")
            let movingColor = UIColor.yellow

            websiteLBL.layer.borderWidth = 1
            websiteLBL.layer.borderColor = movingColor.cgColor
        // what moves and places the label in a new position
        case .changed:
            self.websiteLBL.center = w.location(in: userCardView)
            print("changed")
        case .ended:
            print("ended")
            websiteLBL.layer.borderWidth = 0

            print(websiteLBL.center)
            UserDefaults.standard.set(websiteLBL.center.x, forKey: "xWebsite")
            UserDefaults.standard.set(websiteLBL.center.y, forKey: "yWebsite")
        default:
            print("Default")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("userCard", owner: self, options: nil)
        self.addSubview(userCardView)
    }

}
