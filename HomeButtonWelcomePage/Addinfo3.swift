//
//  Addinfo3.swift
//  HomeButtonWelcomePage
//
//  Created by ruubyan on 2017/11/12.
//  Copyright © 2017年 Team#2. All rights reserved.
//
import UIKit

class Addinfo3: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var streetText: UITextField!
    @IBOutlet weak var AptText: UITextField!
    @IBOutlet weak var CityText: UITextField!
    @IBOutlet weak var StateText: UITextField!
    @IBOutlet weak var ZIPText: UITextField!
    
    
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
        streetText.delegate = self
        AptText.delegate = self
        CityText.delegate = self
        StateText.delegate = self
        ZIPText.delegate = self
    }
    
    @IBAction func NextButtonTapped(_ sender: UIButton) {
        let street = streetText.text
        let apt = AptText.text
        let city = CityText.text
        let state = StateText.text
        let zip = ZIPText.text
        
        if (street?.isEmpty ?? true){
            displayAlertMessage(userMessage: "Street is required")
            return
        } else if (city?.isEmpty ?? true) {
            displayAlertMessage(userMessage: "City is required")
            return
        } else if (state?.isEmpty ?? true){
            displayAlertMessage(userMessage: "State is required")
            return
        } else if (zip?.isEmpty ?? true){
            displayAlertMessage(userMessage: "zip is required")
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
