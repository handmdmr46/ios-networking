//
//  TestMapViewController.swift
//  MyOnTheMapApp
//
//  Created by martin hand on 10/30/15.
//  Copyright © 2015 martin hand. All rights reserved.
//

import UIKit
import MapKit

class TestMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView : MKMapView!
    
    @IBOutlet weak var textField : UITextField!
    @IBOutlet weak var headerLabel : UILabel!
    @IBOutlet weak var submitButton : BorderedButton!
    
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!

    override func viewDidLoad() {
        super.viewDidLoad()

        headerLabel.backgroundColor = UIColor.grayColor()
        headerLabel.text = "submit text to search:"
        
    }
    
    @IBAction func searchTextMapTestButtonTouchUp(sender: AnyObject) {
        
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = textField.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (response, error) -> Void in
            
            if response == nil{
                //TODO: error handling for no response
                
                // alert window error response sample
                let alertController = UIAlertController(title: "Search Error", message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                
                // send error message to a debug text label in FindOnMapSubView
                
                
                return
            }
            
            let latitude : Double = response!.boundingRegion.center.latitude
            let longitude : Double = response!.boundingRegion.center.longitude
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let span = MKCoordinateSpanMake(0.003, 0.003)
            let region = MKCoordinateRegionMake(coordinate, span)
            self.mapView.setRegion(region, animated:true)
            
            let annotation = MKPointAnnotation()
            annotation.title = self.textField.text
            annotation.coordinate = coordinate
            self.mapView.addAnnotation(annotation)
        }
        
    }
    
   

}
