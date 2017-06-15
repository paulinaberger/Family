//
//  ViewController.swift
//  Swiftagram
//
//  Created by Paulina Berger on 2017-05-10.
//  Copyright © 2017 Paulina Berger. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit


class ViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning() 
     }
    
    

    @IBAction func signinTapped(_ sender: Any) {
        
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        FIRAuth.auth()?.signIn(withEmail: username!, password: password!) { (user, error) in
            if error != nil {
                // error loggin in user
                
                let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message: "Wrong password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
           
            }else {
                //success
                let alert = UIAlertController(title: "success", message: "You are logged in!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}


