//
//  AddInfo.swift
//  HomeButtonWelcomePage
//
//  Created by ruubyan on 2017/11/11.
//  Copyright © 2017年 Team#2. All rights reserved.
//

import UIKit

class AddInfo: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmpw: UITextField!
    
    
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
        email.delegate = self
        username.delegate = self
        password.delegate = self
        confirmpw.delegate = self
    }
    
    @IBAction func NextButtonTapped(_ sender: UIButton) {
        let useremail = email.text;
        let userpassword = password.text;
        let usernametext = username.text;
        let usercfpassword = confirmpw.text;
        
        if (useremail?.isEmpty ?? true) {
            displayAlertMessage(userMessage: "Email is required")
            return
        } else if (usernametext?.isEmpty ?? true){
            displayAlertMessage(userMessage: "Username is required")
            return
        } else if (userpassword?.isEmpty ?? true){
            displayAlertMessage(userMessage: "Password is required")
            return
        } else if (usercfpassword?.isEmpty ?? true){
            displayAlertMessage(userMessage: "Please confirm your password")
            return
        }
        
        if (userpassword != usercfpassword){
            displayAlertMessage(userMessage: "Password do not match")
            
            return
        }
        
        //UserDefaults.stan
        
    }
    
    func displayAlertMessage(userMessage:String){
        var myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle:UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title:"OK", style:UIAlertActionStyle.default,handler:nil);
        
        myAlert.addAction(okAction)
        
        self.present(myAlert,animated: true ,completion: nil)
    }
}
