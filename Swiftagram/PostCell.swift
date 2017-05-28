//
//  PostCell.swift
//  Swiftagram
//
//  Created by Paulina Berger on 2017-05-25.
//  Copyright © 2017 Paulina Berger. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class PostCell: UICollectionViewCell {
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!

 
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var unlikeButton: UIButton!
    
    var postID: String!
    
    
    
    
    @IBAction func likesPressed(_ sender: Any) {
        
        self.likesButton.isEnabled = false
        
        //need to connect to DB
        
        let ref = FIRDatabase.database().reference()
        let keyToPost = ref.child("posts").childByAutoId().key
        
        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let post = snapshot.value as? [String : AnyObject] {
                
                let updateLikes: [ String : Any] = ["peopleWhoLike/\(keyToPost)" : FIRAuth.auth()!.currentUser!.uid]
          
                ref.child("posts").child(self.postID).updateChildValues(updateLikes, withCompletionBlock: { (error, reff) in
                
                    if error == nil {
                ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: {snap in
                    if let properties = snap.value as? [String : AnyObject]{
                        
                        if let likes = properties["peopleWhoLike"] as? [String: AnyObject] {
                            let count = likes.count
                            self.likesLabel.text = "\(count) Likes"
                            
                            
                            let update = ["Likes" : count]
                            ref.child("posts").child(self.postID).updateChildValues(update)
                            
                            self.likesButton.isHidden = true
                            self.unlikeButton.isHidden = false
                            self.likesButton.isEnabled = true
                        }
                    }
                    })
                    }
                })
            }
        })
        
        ref.removeAllObservers()
    }
    
   
    @IBAction func unlikePressed(_ sender: Any) {
        self.unlikeButton.isEnabled = false
        let ref = FIRDatabase.database().reference()
        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let properties = snapshot.value as? [String : AnyObject] {
                
                if let peopleWhoLike = properties["peopleWhoLike"] as? [String : AnyObject] {
                    
                    for (id,person) in peopleWhoLike {
                        if person as? String == FIRAuth.auth()!.currentUser!.uid {
                            
                            ref.child("posts").child(self.postID).child("peopleWhoLike").child(id).removeValue(completionBlock: { (error, reff) in
                                if error == nil {
                                    ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snap) in
                                        if let prop = snap.value as? [String : AnyObject] {
                                            if let likes = prop["peopleWhoLike"] as?  [String : AnyObject] {
                                                let count = likes.count
                                                self.likesLabel.text = "\(count) Likes"
                                                ref.child("posts").child(self.postID).updateChildValues(["likes" : count])
                                            }else {
                                                self.likesLabel.text =  "0 Likes"
                                                ref.child("posts").child(self.postID).updateChildValues(["likes" : 0])
                                            }
                                        }
                                        
                                    })
                                }
                            })
                            self.likesButton.isHidden = false
                            self.unlikeButton.isHidden = true
                            self.unlikeButton.isEnabled = true
                            break
                        }
                        
                    }
                }
            }
        })
        
        ref.removeAllObservers()
    }
}
