//
//  ViewController.swift
//  HomeButtonWelcomePage
//
//  Created by ruubyan on 2017/11/10.
//  Copyright © 2017年 Team#2. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool){
        self.performSegue(withIdentifier: "Login", sender: self)
    }

}

