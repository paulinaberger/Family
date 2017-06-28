//
//  BaseViewController.swift
//  Swiftagram
//
//  Created by MAC1 on 08/06/2017.
//  Copyright © 2017 Paulina Berger. All rights reserved.
//

import UIKit


class BaseViewController: UIViewController {

    var container: UIView!
    var actIdc = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func showActivityIndicator() {
        container = UIView()
        container.frame = view.frame
        container.center = view.center
        container.backgroundColor = UIColor(white: 0, alpha: 0.8)
        
        actIdc.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actIdc.hidesWhenStopped = true
        actIdc.center = CGPoint(x: container.frame.size.width / 2, y: container.frame.size.height / 2)
        
        container.addSubview(actIdc)
        view.addSubview(container)
        
        actIdc.startAnimating()
    }
    
    func dismissActivityIndicator() {
        container.removeFromSuperview()
    }
 

}
