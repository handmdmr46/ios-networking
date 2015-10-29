//
//  TableViewController.swift
//  MyOnTheMapApp
//
//  Created by martin hand on 10/28/15.
//  Copyright © 2015 martin hand. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
        
        barButtonArray.append(UIBarButtonItem(title: "Post", style: .Plain, target: self, action: "informationPostingViewButtonTouchUp"))
        barButtonArray.append(UIBarButtonItem(title: "Reload", style: .Plain, target: self, action: "refreshButtonTouchUp"))
        
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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func refreshButtonTouchUp() {
        print("refreshButtonTouchUp")
    }
    
    func informationPostingViewButtonTouchUp() {
        print("informationPostingViewButtonTouchUp")
    }
    
    // MARK: table delegate functions
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellReuseIdentifier = "StudentTableViewCell"
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
        
        //TODO: open web view - launch Safari and direct it to the link associated with the student
        
        //let vc = self.storyboard!.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
        
        let student = students[indexPath.row]
        let urlString = student.mediaURL
        let url = NSURL(string: urlString)!
        let urlRequest = NSURLRequest(URL: url)
        
      //  vc.urlRequest = urlRequest
      //  vc.navagationTitle = urlString
        
        let nav = UINavigationController()
        
     //   nav.pushViewController(vc, animated: true)
        
        self.presentViewController(nav, animated: true, completion: nil)
        
        //self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
}
