//
//  InformationPostViewController.swift
//  MyOnTheMapApp
//
//  Created by martin hand on 10/29/15.
//  Copyright © 2015 martin hand. All rights reserved.
//

import UIKit

class InformationPostViewController: UIViewController {
    
    @IBOutlet weak var headerTextLabel : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "cancel", style: .Plain, target: self, action: "cancelInformationPostViewControllerButtonTouchUp")
        
        headerTextLabel.text = "Where are you studying today?"

        self.configureUI()
    }
    
    func cancelInformationPostViewControllerButtonTouchUp() {
        
    }

    /*
    ** configure user interface example used from udacity tutorial, this is a job for the front end developer, also any class in the view folder
    */
    func configureUI() {
        /* Configure background gradient */
        self.view.backgroundColor = UIColor.clearColor()
        let colorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).CGColor
        let colorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).CGColor
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        self.view.layer.insertSublayer(backgroundGradient, atIndex: 0)
        
        /* Configure header text label */
        headerTextLabel.font = UIFont(name: "AvenirNext-Medium", size: 24.0)
        headerTextLabel.textColor = UIColor.whiteColor()
        
        /* Configure debug text label */
        /*debugTextLabel.font = UIFont(name: "AvenirNext-Medium", size: 20)
        debugTextLabel.textColor = UIColor.whiteColor()*/
        
        // Configure login button
        /*loginButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        loginButton.highlightedBackingColor = UIColor(red: 0.0, green: 0.298, blue: 0.686, alpha:1.0)
        loginButton.backingColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        loginButton.backgroundColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)*/
    }

}
