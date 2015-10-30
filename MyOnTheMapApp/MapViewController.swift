//
//  MapViewController.swift
//  MyOnTheMapApp
//
//  Created by martin hand on 10/28/15.
//  Copyright © 2015 martin hand. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, SFSafariViewControllerDelegate {
    
    // MARK: properties
    
    @IBOutlet var mapView : MKMapView!
    let locationManager = CLLocationManager()
    var students: [Student] = [Student]()
    var latitude : Double = 45.421362
    var longitude : Double = -122.644190
    var barButtonArray: [UIBarButtonItem] = [UIBarButtonItem]()
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.parentViewController!.navigationItem.title = "Students Map"
        self.parentViewController!.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logoutButtonTouchUp")
        
        barButtonArray.append(UIBarButtonItem(image: UIImage(named: "plus"), style: .Plain, target: self, action: "informationPostingViewButtonTouchUp"))
        barButtonArray.append(UIBarButtonItem(image: UIImage(named: "reload"), style: .Plain, target: self, action: "reloadStudentsButtonTouchUp"))
        
        self.parentViewController!.navigationItem.rightBarButtonItems = barButtonArray
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.distanceFilter = 100.0; // Will notify the LocationManager every 100 meters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.requestLocation()
        
        // get student location objects
        Client.sharedInstance().getParseStudentLocationObjects({ (students, error) in
            
            if let students = students {
                
                self.students = students
                
                for student in students {
                    var annotation: MKPointAnnotation!
                    annotation = MKPointAnnotation()
                    let coordinate = CLLocationCoordinate2DMake(student.latitude, student.longitude)
                    annotation.coordinate = coordinate
                    annotation.title = student.firstName
                    annotation.subtitle = student.mediaURL
                    self.mapView.addAnnotation(annotation)
                }
            }
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: actions, called from bar button items
    
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
        print("informationPostingViewButtonTouchUp")
    }
    
    
    // MARK: map view delegate functions
    
    /*
    ** adding animate pin drop, and information button to annotation description window
    */
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
        }
        
        let button = UIButton(type: UIButtonType.DetailDisclosure)
        
        pinView?.rightCalloutAccessoryView = button
        
        return pinView
    }
    
    /*
    ** open web view from annotation subtitle which is supposed to be a url, could add some string validation here
    */
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let urlString = view.annotation?.subtitle!
        let url = NSURL(string: urlString!)!
        
        let safari = SFSafariViewController(URL: url)
        safari.delegate = self
        
        presentViewController(safari, animated: true, completion: nil)
    }
    
    // MARK: location manager functions
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)")
            let coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            //let span = MKCoordinateSpanMake(0.003, 0.003) // within neighborhood block
            //let span = MKCoordinateSpanMake(0.3, 0.3) // within portland
            //let span = MKCoordinateSpanMake(3.3, 3.3) // shows a few states
            let span = MKCoordinateSpanMake(13.3, 13.3) // shows united states
            let region = MKCoordinateRegionMake(coordinate, span)
            self.mapView.setRegion(region, animated:true)
            self.mapView.showsUserLocation = true;
            self.mapView.reloadInputViews()
            //manager.stopUpdatingLocation() // doesn't work, function still called 3X's, this is okay though, called as accuracy increases.
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
        //let coordinate = CLLocationCoordinate2DMake(37.331652997806785, -122.03072304117417)//apple headquarters california - default for simulator
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)//mdhmotors in milwaukie, or
        //let span = MKCoordinateSpanMake(0.003, 0.003) // within neighborhood block
        //let span = MKCoordinateSpanMake(0.3, 0.3) // within portland
        let span = MKCoordinateSpanMake(3.3, 3.3) // shows a few states
        //let span = MKCoordinateSpanMake(13.3, 13.3) // shows united states
        let region = MKCoordinateRegionMake(coordinate, span)
        mapView.setRegion(region, animated:true)
    }
    
    
}
