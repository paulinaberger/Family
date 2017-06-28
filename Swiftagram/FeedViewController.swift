//
//  FeedViewController.swift
//  Swiftagram
//
//  Created by Paulina Berger on 2017-05-24.
//  Copyright © 2017 Paulina Berger. All rights reserved.
//

import UIKit
import Firebase


class FeedViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts = [Post]()
    var following = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPosts()
    }
    
    func fetchPosts(){
        
        
        //reference to database in order to get snapshots
        
        let ref = FIRDatabase.database().reference()
        
        //grab all users from current user
        
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with:  {  snapshot in
       
            let users = snapshot.value as! [String : AnyObject] //string is unique identifier of user
        
            //loop through users, check user id and see if it matches to user
            
            for (_, value) in users {//value is AnyObject//
                
                if let uid = value["uid"] as? String {
                    if uid == FIRAuth.auth()?.currentUser?.uid {
                        if let followingUsers = value["following"] as? [String : String] {
                            
                            for(_, user) in followingUsers {
                                self.following.append(user) //will finish for as many people as it has
                            }
                        }
                        self.following.append(FIRAuth.auth()!.currentUser!.uid)
                        
                        
                        ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in

                            
                            let postsSnap = snap.value as! [String : AnyObject]
                            
                            for (_, post) in postsSnap {
                                if let userID = post["userID"] as? String {
                                    for each in self.following{
                                        if each == userID {
                                            let posst = Post()
                                            if let author = post["author"] as? String, let likes = post["likes"] as? Int, let pathToImage = post["pathToImage"] as? String, let postID = post["postID"] as? String {
                                                posst.author =  author
                                                posst.likes = likes
                                                posst.pathToImage = pathToImage
                                                posst.postID = postID
                                                posst.userID = userID
                                                
                                                if let people = post["peopleWhoLike"] as? [String : Any] {
                                                    for (_, person) in people {
                                                        posst.peopleWhoLike.append(person as! String)
                                                        
                                                        }
                                                    }
                                                
                                                self.posts.append(posst)
                                            }
                                        }
                                    }
                                    
                                    self.collectionView.reloadData()
                                }
                            }
                        })
                    }
                }
            }
        })
        
        ref.removeAllObservers()
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath ) as! PostCell
        
        
        //creating a cell
        //Need to connect to FIREBASE to get all of the posts
        cell.postImage.downloadImage(from: self.posts[indexPath.row].pathToImage)
        cell.authorLabel.text = self.posts[indexPath.row].author
        cell.likesLabel.text = "\(self.posts[indexPath.row].likes!) Likes"
        cell.postID = self.posts[indexPath.row].postID
        
        for person in self.posts[indexPath.row].peopleWhoLike {
            if person == FIRAuth.auth()!.currentUser!.uid {
                cell.likesButton.isHidden = true
                cell.unlikeButton.isHidden = false
                break
            }
        }
        return cell
    }
}
