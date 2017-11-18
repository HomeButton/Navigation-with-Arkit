//
//  Login.swift
//  HomeButtonWelcomePage
//
//  Created by ruubyan on 2017/11/10.
//  Copyright © 2017年 Team#2. All rights reserved.
//
import UIKit

class Login: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func LoginButtonTapped(_ sender: UIButton) {
        let Username = username.text
        let Password = password.text
   }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        username.delegate = self
        password.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return(true)
    }
    

}
