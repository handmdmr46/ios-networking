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
        
        Client.sharedInstance().deleteUdacitySession({ (success, logoutResponse, errorString) in
            
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            } else {
                let alertController = UIAlertController(title: "Logout Error", message: "Logout attempt failed please try again", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        })
    }
    
    func reloadStudentsButtonTouchUp() {
        print("reloadStudentsButtonTouchUp")
        
        Client.sharedInstance().getParseStudentLocationObjects({ (students, error) in
            
            if let students = students {
                
                self.students = students
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
                
            }
        })
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
