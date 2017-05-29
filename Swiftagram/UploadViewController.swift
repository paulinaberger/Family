//
//  UploadViewController.swift
//  Swiftagram
//
//  Created by Paulina Berger on 2017-05-22.
//  Copyright © 2017 Paulina Berger. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
    }

    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    
    
    let picker = UIImagePickerController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.allowsEditing = true
        
              }
    
    
    @IBAction func selectPressed(_ sender: Any) {
        
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
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.previewImage.image = image
            selectButton.isHidden = true
            postButton.isHidden = false
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

    
    @IBAction func postPressed(_ sender: Any) {
        AppDelegate.instance().showActivityIndicator()
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        let storage = FIRStorage.storage().reference(forURL: "gs://swiftagram-62eb3.appspot.com")
  
        let key = ref.child("posts").childByAutoId().key
        let imageRef = storage.child("posts").child(uid).child("\(key).jpg")
        
        let data = UIImageJPEGRepresentation(self.previewImage.image!, 0.6)
        
        let uploadTask = imageRef.put(data!, metadata: nil) { (metadata, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                AppDelegate.instance().dismissActivityIndicator()
                return
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                if let url = url {
                    let feed = ["userID" : uid,
                                "pathToImage" : url.absoluteString,
                                "likes" : 0,
                                "author" : FIRAuth.auth()!.currentUser!.displayName!,
                                "postID" : key] as [String : Any]
                    
                    //creating a specific ID and including tasks under this branch
                        let postFeed=["\(key)" : feed]
                    
                    ref.child("posts").updateChildValues(postFeed)
                    
                    AppDelegate.instance().dismissActivityIndicator()
                    
                    self.dismiss(animated: true, completion: nil)
                 }
            })
        }
        
        uploadTask.resume()

    }
}
