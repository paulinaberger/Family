	//
//  RegisteredUserUIController.swift
//  Swiftagram
//
//  Created by MAC1 on 22/06/2017.
//  Copyright © 2017 Paulina Berger. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAnalytics
import FirebaseAuth


class RegisteredUserUIController: UIViewController {
    
    
    
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    @IBOutlet weak var FullName: UILabel!
    @IBOutlet weak var userEmail: UILabel!

    @IBOutlet weak var uniqueidentifier: UILabel!
    
    @IBOutlet weak var userPicture: UIImageView!
    
    var dataBaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    var storageRef: FIRStorage {
        return FIRStorage.storage()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInfo()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
    }
    
  func loadUserInfo() {
    
    
        let userRef = dataBaseRef.child("users/\(FIRAuth.auth()!.currentUser!.uid)")
     userRef.observe(.value, with: { (snapshot) in
        
        
  if let dict = snapshot.value as?  [String: AnyObject]  {
        
            self.FullName.text = dict["Full Name"] as? String
            self.userEmail.text = FIRAuth.auth()!.currentUser!.email
            self.uniqueidentifier.text = dict["uid"] as? String
            
         } 
 
        
    /*    
         
        let imageUrl = user.photoURL!
        
        self.storageRef.reference(forURL: imageUrl).data(withMaxSize: 1 * 1024 * 1024, completion: { (imgData, error) in
            
            if error == nil {
                if let data = imgData {
                    self.userPicture.image = UIImage(data: data)
                } else {
                    print(error!.localizedDescription)
                }
                
            }
            
        }) 
         
    */
     

        })  {(error) in
        print(error.localizedDescription)
        
        // create the alert
        let alert = UIAlertController(title: "Database Connection Error", message: "Sorry, We can`t retrieve your personal data", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)

        
        }
        
        
    
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
