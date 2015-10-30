//
//  TableViewController.swift
//  MyOnTheMapApp
//
//  Created by martin hand on 10/28/15.
//  Copyright © 2015 martin hand. All rights reserved.
//

import UIKit
import SafariServices

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SFSafariViewControllerDelegate  {
    
    // MARK: properties
    var students: [Student] = [Student]()
    var barButtonArray: [UIBarButtonItem] = [UIBarButtonItem]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // TODO: create and set logout button, create upload button and action
        self.parentViewController!.navigationItem.title = "Students"
        self.parentViewController!.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logoutButtonTouchUp")
        
        barButtonArray.append(UIBarButtonItem(image: UIImage(named: "plus"), style: .Plain, target: self, action: "informationPostingViewButtonTouchUp"))
        barButtonArray.append(UIBarButtonItem(image: UIImage(named: "reload"), style: .Plain, target: self, action: "reloadStudentsButtonTouchUp"))
        
        self.parentViewController!.navigationItem.rightBarButtonItems = barButtonArray
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        Client.sharedInstance().getParseStudentLocationObjects({ (students, error) in
            
            if let students = students {
                
                self.students = students
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
                
            }
        })
    }
    
    // MARK: actions
    
    func logoutButtonTouchUp() {
        
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        
        Client.sharedInstance().deleteUdacitySession({ (success, logoutResponse, errorString) in
            
            if success {
                vc.debugTextLabel.text = "Logged Out " + logoutResponse!
            } else {
                vc.debugTextLabel.text = "Logged Out ERROR"
            }
        })
        
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(vc, animated: true, completion: nil)
        })
    }
    
    func reloadStudentsButtonTouchUp() {
        print("reloadStudentsButtonTouchUp")
    }
    
    func informationPostingViewButtonTouchUp() {
        
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostViewController") as! InformationPostViewController
        
        let navigation = UINavigationController()
        
        navigation.pushViewController(controller, animated: true)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(navigation, animated: true, completion: nil)
        })
    }
    
    // MARK: table delegate functions
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellReuseIdentifier = "TableViewCell"
        let student = students[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        cell.textLabel?.text = "STUDENT: " + student.firstName + " " + student.lastName + "\nFROM: \(student.mapString) \nURL: \(student.mediaURL)"
        //cell.detailTextLabel?.text = student.mapString
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let student = students[indexPath.row]
        
        let urlString = student.mediaURL
        let url = NSURL(string: urlString)!
        
        let safari = SFSafariViewController(URL: url)
        safari.delegate = self
        
        presentViewController(safari, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
}
