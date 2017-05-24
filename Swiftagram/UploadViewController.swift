//
//  UploadViewController.swift
//  Swiftagram
//
//  Created by Paulina Berger on 2017-05-22.
//  Copyright © 2017 Paulina Berger. All rights reserved.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    

    @IBOutlet weak var previewImage: UIImageView!
    
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var postButton: UIButton!
    
    
    var picker = UIImagePickerController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        
      }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage]as? UIImage {
        self.previewImage.image = image
            selectButton.isHidden = true
            postButton.isHidden = false
      }
        self.dismiss(animated: true, completion: nil)
}

    @IBAction func selectPressed(_ sender: Any) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func postPressed(_ sender: Any) {
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        let storage = FIRStorage.storage().reference(forURL: "https://swiftagram-62eb3.firebaseio.com/")
  
        let key = ref.child("posts").childByAutoId().key
        let imageRef = storage.child("posts").child(uid).child("\(key).jpg")
        
        let data = UIImageJPEGRepresentation(self.previewImage.image!, 0.6)
        
        let uploadTask = imageRef.put(data!, metadata: nil) { (metadata, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                if let url = url {
                    let feed = ["userid": uid], "pathToImage": url.absoluteString(), "likes": 0, "author" : FIRAuth.auth().currentUser!.displayName!()
                }
            })
        }
    }
    

}
