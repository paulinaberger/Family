//
//  SignUpViewController.swift
//  Swiftagram
//
//  Created by Paulina Berger on 2017-05-15.
//  Copyright © 2017 Paulina Berger. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage


class SignUpViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var FullName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var signUpNext: UIButton!
    
    var picker = UIImagePickerController()
    var userStorage = FIRStorageReference()
    var ref: FIRDatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.height/4
        imageView.clipsToBounds = true


        let storage = FIRStorage.storage().reference(forURL: "gs://swiftagram-62eb3.appspot.com")
    
        ref = FIRDatabase.database().reference()

        userStorage = storage.child("users")
    }
    
 
    

    @IBAction func selectImagePressed(_ sender: Any) {
        
        let alertViewController = UIAlertController(title: "Want to display a pic?", message: "You can either select it or snap it", preferredStyle: .actionSheet)
        let galleryAction = UIAlertAction(title: "Choose from gallery", style: .default, handler: { action in
            self.openGallery()
        })
        let cameraAction = UIAlertAction(title: "Take photo", style: .default, handler: { action in
            self.openCamera()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("cancel")
        })
        alertViewController.addAction(cameraAction)
        alertViewController.addAction(galleryAction)
        alertViewController.addAction(cancelAction)
        present(alertViewController, animated: true, completion: nil)
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.imageView.image = image
            
            //want to unhide the Sign me UP! button
            signUpNext.isHidden = false
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            picker.cameraDevice = .front
            present(picker, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    
    
    
    
    
    @IBAction func signUpNextPressed(_ sender: Any) {
        
        guard FullName.text != "", userEmail.text != "", password.text != "", confirmPassword.text != "" else {return}
        
        if password.text == confirmPassword.text{
            
            FIRAuth.auth()?.createUser(withEmail: userEmail.text!, password: password.text!, completion: { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let user = user {
                    
                    let changeRequest = FIRAuth.auth()!.currentUser!.profileChangeRequest()
                    changeRequest.displayName = self.FullName.text!
                    changeRequest.commitChanges(completion: nil)
                    
                    
                    let imageRef = self.userStorage.child("\(user.uid).jpg")
                    
                    let data = UIImageJPEGRepresentation(self.imageView.image!, 0.5)
                    
                    //upload task
                    let uploadTask = imageRef.put(data!, metadata: nil, completion: { (metadata, err) in
                        if err != nil {
                            print(err!.localizedDescription)
                        }
                        
                        imageRef.downloadURL(completion: { (url, er) in
                            if er != nil {
                                print(er!.localizedDescription)
                            }
                            
                            if let url = url {
                                
                                let userInfo: [String : Any] = ["uid" : user.uid,"Full Name": self.FullName.text,"urltoImage" : url.absoluteString]
                                self.ref.child("users").child(user.uid).setValue(userInfo)
                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "usersVC")
                                self.present(vc, animated: true, completion: nil)
                            }
                        })
                    })
                    
                    uploadTask.resume()
                }
            })
            
        } else {
            print("Password does not match")

        }
    }
}


