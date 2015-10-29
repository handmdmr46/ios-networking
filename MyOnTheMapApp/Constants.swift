//
//  Constants.swift
//  MyOnTheMapApp
//
//  Created by martin hand on 10/28/15.
//  Copyright © 2015 martin hand. All rights reserved.
//

extension Client {
    
    struct Constants {
        static let UdacityFacebookApiKey : String = "365362206864879"
        static let UdacityBaseURL : String = "https://www.udacity.com/"
        static let ParseBaseURL : String = "https://api.parse.com/"
        
    }
    
    struct Methods {
        static let UdacitySession : String = "api/session"
        static let UdacityGetPublicUsers : String = "api/users/{id}"
        static let ParseStudentLocation : String = "1/classes/StudentLocation"
    }
    
    struct JSONBodyKeys {
        static let UserName = "username"
        static let Password = "password"
    }
    
    struct APIKeys {
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ParseRESTApiID = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct HTTPHeaderKeys {
        static let ParseApplicationIDKey = "X-Parse-Application-Id"
        static let ParseRESTApiKey = "X-Parse-REST-API-Key"
        static let ParseContentType = "Content-Type"
        static let UdacityAccept = "Accept"
        static let UdacityContentType = "Content-Type"
    }
    
    struct HTTPBodyKeys {
        static let ParseUniqueKey = "uniqueKey"
        static let ParseFirstName = "firstName"
        static let ParseLastName = "lastName"
        static let ParseMapString = "mapString"
        static let ParseMediaURL = "mediaURL"
        static let ParseLatitude = "latitude"
        static let ParseLongitude = "longitude"
        static let UdacityUsername = "username"
        static let UdacityPassword = "password"
        static let UdacityKey = "udacity"
        static let UdacityFacebookMobile = "facebook_mobile"
        static let UdacityFacebookToken = "access_token"
    }
    
    struct ParseJSONResponseKeys {
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
    }
    
}