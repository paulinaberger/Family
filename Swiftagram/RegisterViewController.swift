//
//  RegisterViewController.swift
//  Swiftagram
//
//  Created by Paulina Berger on 2017-05-12.
//  Copyright © 2017 Paulina Berger. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccountTapped(_ sender: Any) {
        
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        
        FIRAuth.auth()?.createUser(withEmail: username!, password: password!,
                                   completion: { (user, error) in
            if error != nil {
                //error creating account
                let alert = UIAlertController(title: "Error", message: "There was an error", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
                self.present(alert, animated: true,
                             completion: nil)
            
            }else{
                //success creating account
                let alert = UIAlertController(title: "Success!", message: "Account Created!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true,
                             completion: nil)
                }
            }
    
    )}
}
