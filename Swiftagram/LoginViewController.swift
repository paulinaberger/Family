//
//  LoginViewController.swift
//  Swiftagram
//
//  Created by Paulina Berger on 2017-05-17.
//  Copyright © 2017 Paulina Berger. All rights reserved.
//

import UIKit
import UIKit
import Firebase
import FirebaseStorage

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginPressed(_ sender: Any) {
        
        guard emailField.text != "", passwordField.text != ""
            else{return}
        
        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
          
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let user = user {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "usersVC")
                
                self.present(vc, animated: true, completion: nil)
            }
        })
        
        
        
    }
 

}
