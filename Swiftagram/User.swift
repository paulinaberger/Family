//
//  User.swift
//  Swiftagram
//
//  Created by Paulina Berger on 2017-05-21.
//  Copyright © 2017 Paulina Berger. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseDatabase

class User: NSObject {
    
    var userID: String!
    var FullName: String!
    var imagePath: String!

    /*
     
    var photoURL: String!
    var ref: FIRDatabaseReference?
    var key: String?
    var uid: String!
    var username: String!
    var email: String?
    
    
 init(snapshot: FIRDataSnapshot){
    
    key = snapshot.key
    ref = snapshot.ref
    /* FullName = (snapshot.value! as! NSDictionary)  ["Full Name"] as! String */
    email = (snapshot.value! as! NSDictionary)  ["email"] as? String
    photoURL = (snapshot.value! as! NSDictionary)  ["photoURL"] as! String
 
}
 
     */
    
    

}
