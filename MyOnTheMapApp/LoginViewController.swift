//
//  LoginViewController.swift
//  MyOnTheMapApp
//
//  Created by martin hand on 10/28/15.
//  Copyright © 2015 martin hand. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import SafariServices

class LoginViewController: UIViewController, SFSafariViewControllerDelegate {
    
    
    
    
    
    
    // MARK: properties
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: BorderedButton!
    @IBOutlet weak var debugTextLabel: UILabel! 
    @IBOutlet weak var headerTextLabel: UILabel!
    @IBOutlet weak var fbLoginButton: BorderedButton!
    var students: [Student] = [Student]()
    var tokenString : String? = nil
    var dict : NSDictionary!
    
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameTextField.text = "martin@mdhmotors.com"
        self.passwordTextField.text = "Hmartin76"
        self.configureUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.debugTextLabel.text = ""
        
        
    }
    
    // MARK: actions
    
    @IBAction func testLoginWithFacebookButtonTouchUp(sender: AnyObject) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager .logInWithReadPermissions(["email"], fromViewController: self.parentViewController, handler: { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                    fbLoginManager.logOut()
                }
            }
        })
    }
    
    @IBAction func loginWithFacebookButtonTouchUp(sender: AnyObject) {
        
        let loginManager = FBSDKLoginManager()
        
        
        loginManager.logInWithReadPermissions(["email"], fromViewController: self.parentViewController, handler: { (result, error) -> Void in
            
            if let error = error {
                print(error)
            } else if result.isCancelled {
                print("Cancelled")
            } else {
                print("LoggedIn")
                
                FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
                
                self.tokenString = FBSDKAccessToken.currentAccessToken().tokenString
                
            }
            
            Client.sharedInstance().facebookAuthenicationWithViewController(self.tokenString!, completionHandler: { (success, errorString) in
                
                if success {
                    self.completeLogin()
                } else {
                    loginManager.logOut()
                    self.displayError(errorString)
                }
            })
            
        })
    }
    
    /*
    ** login with udacity
    */
    @IBAction func loginButtonTouchUp(sender: AnyObject) {
        
        Client.sharedInstance().authenticateWithViewController(usernameTextField.text!, password: passwordTextField.text!, completionHandler: { (success, errorString) in
            
            if success {
                self.completeLogin()
            } else {
                self.displayError(errorString)
            }
        })
    }
    
    /*
    ** get safari web browser, udacity account sign up page     
    */
    @IBAction func goToUdacitySignUpButtonTouchUp(sender: AnyObject) {
        
        let urlString = "https://www.udacity.com/account/auth#!/signup"
        let url = NSURL(string: urlString)!
        let safari = SFSafariViewController(URL: url)
        safari.delegate = self
        presentViewController(safari, animated: true, completion: nil)
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    ** test facebook login button
    */
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! NSDictionary
                    print(result)
                    print(self.dict)
                    NSLog(self.dict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as! String)
                }
            })
        }
    }
    
    /*
    ** login success, move to tab view controller
    */
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            self.debugTextLabel.text = ""
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarNavigationController") as! UINavigationController
            self.presentViewController(vc, animated: true, completion: nil)
        })
    }
    
    // MARK: user interface
    
    func displayError(errorString: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            if let errorString = errorString {
                self.debugTextLabel.text = errorString
            }
        })
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
        debugTextLabel.font = UIFont(name: "AvenirNext-Medium", size: 20)
        debugTextLabel.textColor = UIColor.whiteColor()
        
        // Configure login button
        loginButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        loginButton.highlightedBackingColor = UIColor(red: 0.0, green: 0.298, blue: 0.686, alpha:1.0)
        loginButton.backingColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        loginButton.backgroundColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
    
}

