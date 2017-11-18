//
//  Addinfo2.swift
//  HomeButtonWelcomePage
//
//  Created by ruubyan on 2017/11/12.
//  Copyright © 2017年 Team#2. All rights reserved.
//

import UIKit

class Addinfo2: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var DBOText: UITextField!
    @IBOutlet weak var PhoneText: UITextField!
    @IBOutlet weak var SymptomText: UITextField!
    @IBOutlet weak var DoctocText: UITextField!
    @IBOutlet weak var ECNameText: UITextField!
    @IBOutlet weak var ECNumText: UITextField!
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return(true)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameText.delegate = self
        DBOText.delegate = self
        PhoneText.delegate = self
        SymptomText.delegate = self
        DoctocText.delegate = self
        ECNumText.delegate = self
        ECNameText.delegate = self
    }
        
    @IBAction func NextButtonTapped(_ sender: UIButton) {
        let name = nameText.text
        let DBO = DBOText.text
        let phone = PhoneText.text
        let symptom = SymptomText.text
        let doctor = DoctocText.text
        let ECName = ECNameText.text
        let ECNum = ECNumText.text
        
        if (name?.isEmpty ?? true) {
            displayAlertMessage(userMessage: "Name is required")
            return
        } else if (DBO?.isEmpty ?? true){
            displayAlertMessage(userMessage: "Date of Birth is required")
            return
        } else if (phone?.isEmpty ?? true){
            displayAlertMessage(userMessage: "Phone is required")
            return
        } else if (ECName?.isEmpty ?? true){
            displayAlertMessage(userMessage: "Emergency Contact Name is required")
            return
        } else if (ECNum?.isEmpty ?? true){
            displayAlertMessage(userMessage: "Emergency Contact Number is required")
            return
        }
    }
        
    func displayAlertMessage(userMessage:String){
        var myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle:UIAlertControllerStyle.alert)
            
        let okAction = UIAlertAction(title:"OK", style:UIAlertActionStyle.default,handler:nil);
            
        myAlert.addAction(okAction)
            
        self.present(myAlert,animated: true ,completion: nil)
    }
    
}

