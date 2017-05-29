//
//  Post.swift
//  Swiftagram
//
//  Created by Paulina Berger on 2017-05-24.
//  Copyright © 2017 Paulina Berger. All rights reserved.
//

import UIKit

class Post: NSObject {
    
    var author: String!
    var likes: Int!
    var pathToImage: String!
    var userID: String!
    var postID: String!
    
    var peopleWhoLike : [String] = [String]()
    

}
