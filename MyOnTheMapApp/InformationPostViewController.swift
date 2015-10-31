//
//  InformationPostViewController.swift
//  MyOnTheMapApp
//
//  Created by martin hand on 10/29/15.
//  Copyright © 2015 martin hand. All rights reserved.
//

import UIKit
import MapKit

class InformationPostViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var findOnMapLabel : UILabel!
    @IBOutlet weak var submitMapLabel : UILabel!
    @IBOutlet weak var findOnMapSubView : UIView!
    @IBOutlet weak var submitMapSubView : UIView!
    @IBOutlet weak var findOnMapButton : BorderedButton!
    @IBOutlet weak var submitMapButton : BorderedButton!
    @IBOutlet weak var findOnMapTextField : UITextField!
    @IBOutlet weak var submitMapTextField : UITextField!
    
    
    var latitude : Double = 45.421362
    var longitude : Double = -122.644190
    
    @IBOutlet weak var mapView : MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "cancel", style: .Plain, target: self, action: "cancelInformationPostViewControllerButtonTouchUp")
        
        findOnMapLabel.text = "Where are you studying today?"
        submitMapLabel.text = "Enter a link associated with your location:"
        
        findOnMapSubView.hidden = false
        submitMapSubView.hidden = true
        
        mapView.delegate = self

        self.configureUI()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        let span = MKCoordinateSpanMake(0.003, 0.003) // within neighborhood block
        //let span = MKCoordinateSpanMake(0.3, 0.3) // within portland
        //let span = MKCoordinateSpanMake(3.3, 3.3) // shows a few states
        //let span = MKCoordinateSpanMake(13.3, 13.3) // shows united states
        
        let region = MKCoordinateRegionMake(coordinate, span)
        self.mapView.setRegion(region, animated:true)
        
        var annotation: MKPointAnnotation!
        annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "MDH Motors"
        annotation.subtitle = "Milwaukie, OR"
        self.mapView.addAnnotation(annotation)

    }
    
    func cancelInformationPostViewControllerButtonTouchUp() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func submitButtonTouchUp(sender: AnyObject) {
        findOnMapSubView.hidden = false
        submitMapSubView.hidden = true
    }
    
    @IBAction func findOnMapButtonTouchUp() {
        findOnMapSubView.hidden = true
        submitMapSubView.hidden = false
    }
    /*
    ** configure user interface example used from udacity tutorial, this is a job for the front end developer, also any class in the view folder
    */
    func configureUI() {
        
        /* background gradient color */
//        self.view.backgroundColor = UIColor.clearColor()
//        let colorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).CGColor
//        let colorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).CGColor
//        let backgroundGradient = CAGradientLayer()
//        backgroundGradient.colors = [colorTop, colorBottom]
//        backgroundGradient.locations = [0.0, 1.0]
//        backgroundGradient.frame = view.frame
//        self.view.layer.insertSublayer(backgroundGradient, atIndex: 0)
        
        /* header text label */
        findOnMapLabel.font = UIFont(name: "AvenirNext-Medium", size: 24.0)
        findOnMapLabel.textColor = UIColor.whiteColor()
        findOnMapLabel.backgroundColor = UIColor.grayColor()
        
        submitMapLabel.font = UIFont(name: "AvenirNext-Medium", size: 24.0)
        submitMapLabel.textColor = UIColor.whiteColor()
        submitMapLabel.backgroundColor = UIColor.grayColor()
        
        /* sub views */

        let colorBottom = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).CGColor
        let colorTop = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).CGColor
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        findOnMapSubView.layer.insertSublayer(backgroundGradient, atIndex: 0)

        
        
        /* Configure debug text label */
//        debugTextLabel.font = UIFont(name: "AvenirNext-Medium", size: 20)
//        debugTextLabel.textColor = UIColor.whiteColor()
        
        /* Configure buttons */
        submitMapButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        submitMapButton.highlightedBackingColor = UIColor(red: 0.0, green: 0.298, blue: 0.686, alpha:1.0)
        submitMapButton.backingColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        submitMapButton.backgroundColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        submitMapButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        findOnMapButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        findOnMapButton.highlightedBackingColor = UIColor(red: 0.0, green: 0.298, blue: 0.686, alpha:1.0)
        findOnMapButton.backingColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        findOnMapButton.backgroundColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        findOnMapButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }

}
