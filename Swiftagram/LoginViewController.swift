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
import FBSDKLoginKit
import FBSDKCoreKit

class LoginViewController: BaseViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = FBSDKLoginButton()
        loginButton.center = view.center
        view.addSubview(loginButton)
        loginButton.delegate = self
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if  error != nil {
            print("Facebook Error \(error)")
            return
        }
        
        print("isCancelled: \(result.isCancelled)")
        print("declined permissions: \(result.declinedPermissions)")
        print("granted permissions: \(result.grantedPermissions)")
        
        if !result.isCancelled{
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Firebase error: \(error)")
                    
                }
                else {
                    let vc = UIStoryboard(name: "Main",
                                          bundle: nil).instantiateViewController(withIdentifier: "usersVC")
                    
                    self.present(vc, animated: true, completion: nil)
                }
            })
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }

    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        print("here")
        FBSDKAccessToken.setCurrent(nil)
        return true
    }
    
    

    @IBAction func loginPressed(_ sender: Any) {
        
        guard emailField.text != "", passwordField.text != ""
            else{return}
        
        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
          
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let user = user  {
                let vc = UIStoryboard(name: "Main",
                                      bundle: nil).instantiateViewController(withIdentifier: "usersVC")
                
                self.present(vc, animated: true, completion: nil)
            }
        })
        
        
        
    }
 

}
