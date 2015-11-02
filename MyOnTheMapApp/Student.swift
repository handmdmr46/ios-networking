//
//  Student.swift
//  MyOnTheMapApp
//
//  Created by martin hand on 10/28/15.
//  Copyright © 2015 martin hand. All rights reserved.
//

import MapKit

struct Student {
    
    // MARK: properties
    
    var objectID = ""
    var uniqueKey = ""
    var firstName = ""
    var lastName = ""
    var mapString = ""
    var mediaURL = ""
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    var createdAt = ""
    var updatedAt = ""
    var annotation : MKPointAnnotation!
    
    init(dictionary: [String : AnyObject]) {
        
        annotation = MKPointAnnotation()
        
        objectID = dictionary[Client.ParseJSONResponseKeys.ObjectID] as! String
        uniqueKey = dictionary[Client.ParseJSONResponseKeys.UniqueKey] as! String
        firstName = dictionary[Client.ParseJSONResponseKeys.FirstName] as! String
        lastName = dictionary[Client.ParseJSONResponseKeys.LastName] as! String
        mapString = dictionary[Client.ParseJSONResponseKeys.MapString] as! String
        mediaURL = dictionary[Client.ParseJSONResponseKeys.MediaURL] as! String
        latitude = dictionary[Client.ParseJSONResponseKeys.Latitude] as! Double
        longitude = dictionary[Client.ParseJSONResponseKeys.Longitude] as! Double
        createdAt = dictionary[Client.ParseJSONResponseKeys.CreatedAt] as! String
        updatedAt = dictionary[Client.ParseJSONResponseKeys.UpdatedAt] as! String
        
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        annotation.coordinate = coordinate
        annotation.title = firstName + " " + lastName
        annotation.subtitle = mediaURL
        
    }
    
    /*
    ** Helper: pass in an array of dictionaries and return an array of StudentLocation objects
    */
    static func studentFromResults(results: [[String : AnyObject]]) -> [Student] {
        
        var students = [Student]()
        
        for result in results {
            students.append(Student(dictionary: result))
        }
        
        return students
        
    }
    
    
}

