//
//  Convenience.swift
//  MyOnTheMapApp
//
//  Created by martin hand on 10/28/15.
//  Copyright © 2015 martin hand. All rights reserved.
//

import Foundation
import UIKit

extension Client {
    
    /*
    ** login to udacity, get udacity user info
    */
    func authenticateWithViewController(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        self.postUdacitySessionID(username, password: password, completionHandler: { (success, errorString) in
            
            if success {
                
                self.getUdacityUserInfo(self.userID, completionHandler: { (success, errorString) in
                    
                    if success {
                        
                        completionHandler(success: true, errorString: nil) // made is this far, success = true
                        
                    } else {
                        completionHandler(success: false, errorString: errorString)
                    }
                })
            } else {
                completionHandler(success: false, errorString: errorString)
            }
        })
    }
    
    /*
    ** login with facebook to udacity, get udacity user info
    */
    func facebookAuthenicationWithViewController(tokenString: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        self.postUdacitySessionIdWithFacebookLogin(tokenString, completionHandler: { (success, errorString) in
            
            if success {
                
                self.getUdacityUserInfo(self.userID, completionHandler: { (success, errorString) in
                    
                    if success {
                        
                        // made it here then success true
                        completionHandler(success: true, errorString: nil)
                        
                    } else {
                        completionHandler(success: false, errorString: errorString)
                    }
                })
            } else {
                completionHandler(success: false, errorString: errorString)
            }
        })
    }
    
    /*
    ** get udacity user info, for use within life cycle(login session) of the app
    */
    func getUdacityUserInfo(userID: String?, completionHandler: (success: Bool, errorString: String?) -> Void) {
        let parameters = [String : AnyObject]()
        let httpHeader = [String : String]()
        let baseURLString = Constants.UdacityBaseURL
        let method = Client.subtituteKeyInMethod(Client.Methods.UdacityGetPublicUsers, key: "id", value: self.userID!)!
        
        taskForGETMethod(method, baseURLString: baseURLString, parameters: parameters, httpHeader: httpHeader, completionHandler: { (result, error) in
            
            if let error = error {
                print(error)
                completionHandler(success: false, errorString: "ERROR: failed to get student location objects")
            } else {
                
                if let userInfo = result["user"] as? [String : AnyObject] {
                    
                    if let userImageURL = userInfo["_image_url"] as? String {
                        self.userImageURL = "http:" + userImageURL
                    } else {
                        completionHandler(success: false, errorString: "ERROR: could not find key '_image_url' in: \(result)")
                    }
                    
                    if let userFirstName = userInfo["first_name"] as? String {
                        self.userFirstName = userFirstName
                    } else {
                        completionHandler(success: false, errorString: "ERROR: could not find key 'first_name' in: \(result)")
                    }
                    
                    if let userLastName = userInfo["last_name"] as? String {
                        self.userLastName = userLastName
                    } else {
                        completionHandler(success: false, errorString: "ERROR: could not find ket 'last_name' in: \(result)")
                    }
                    
                    completionHandler(success: true, errorString: nil)
                    
                } else {
                    completionHandler(success: false, errorString: "ERROR: could not find key 'user' in: \(result)")
                }
            }
        })
        
    }
    
    /*
    ** login to udacity with facebook, start udacity login session
    */
    func postUdacitySessionIdWithFacebookLogin(tokenString: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        let method = Client.Methods.UdacitySession
        
        let baseURLString = Client.Constants.UdacityBaseURL
        
        let parameters = [String : AnyObject]()
        
        let _httpBody : [String : String] = [
            Client.HTTPBodyKeys.UdacityFacebookToken : tokenString
        ]
        
        let httpBody : [String :[String : String]] = [
            Client.HTTPBodyKeys.UdacityFacebookMobile : _httpBody
        ]
        
        let httpHeader : [String : String] = [
            Client.HTTPHeaderKeys.UdacityAccept : "application/json",
            Client.HTTPHeaderKeys.UdacityContentType : "application/json"
        ]
        
        taskForPOSTMethod(method, baseURLString: baseURLString, parameters: parameters, httpBody: httpBody, httpHeader: httpHeader, completionHandler: { (result, error) in
            
            if let error = error {
                print(error)
                completionHandler(success: false, errorString: "FACEBOOK LOGIN FAILED: please re-check your login credentials and try again")
            } else {
                
                // session id
                if let sessionResult = result["session"] as? [String : AnyObject] {
                    
                    if let sessionID = sessionResult["id"] as? String {
                        
                        self.sessionID = sessionID
                        
                    } else {
                        completionHandler(success: false, errorString: "FACEBOOK LOGIN FAILED: could not find key 'id' in \(sessionResult)")
                    }
                    
                } else {
                    completionHandler(success: false, errorString: "FACEBOOK LOGIN FAILED: could not find key 'session' in \(result)")
                }
                
                // user id
                if let accountResults = result["account"] as? [String : AnyObject] {
                    
                    if let userID = accountResults["key"] as? String {
                        
                        self.userID = userID
                        
                    } else {
                        completionHandler(success: false, errorString: "FACEBOOK LOGIN FAILED: could not find key 'key' in \(result)")
                    }
                } else {
                    completionHandler(success: false, errorString: "FACEBOOK LOGIN FAILED: could not find key 'account' in \(result)")
                }
                
                // made it here then success true
                completionHandler(success: true, errorString: nil)
            }
        })
    }
    
    /*
    ** login to udacity, start udacity login session
    */
    func postUdacitySessionID(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let method = Client.Methods.UdacitySession
        
        let baseURLString = Client.Constants.UdacityBaseURL
        
        let parameters = [String : AnyObject]()
        
        let _httpBody : [String : String] = [
            Client.HTTPBodyKeys.UdacityUsername : username,
            Client.HTTPBodyKeys.UdacityPassword : password
        ]
        
        let httpBody : [String : [String:String]] = [Client.HTTPBodyKeys.UdacityKey : _httpBody]
        
        let httpHeader : [String : String] = [
            Client.HTTPHeaderKeys.UdacityAccept : "application/json",
            Client.HTTPHeaderKeys.UdacityContentType : "application/json"
        ]
        
        taskForPOSTMethod(method, baseURLString: baseURLString, parameters: parameters, httpBody: httpBody, httpHeader: httpHeader, completionHandler: { (result, error) in
            
            if let error = error {
                print(error)
                completionHandler(success: false, errorString: "LOGIN FAILED: failed to start udacity session, please re-check your login credentials")
            } else {
                
                // session id
                if let sessionResult = result["session"] as? [String : AnyObject] {
                    
                    if let sessionID = sessionResult["id"] as? String {
                        
                        self.sessionID = sessionID
                        
                    } else {
                        completionHandler(success: false, errorString: "LOGIN FAILED: could not find key 'id' in: \(sessionResult)")
                    }
                } else {
                    completionHandler(success: false, errorString: "LOGIN FAILED: could not find key 'session' in: \(result)")
                }
                
                // user id
                if let accountResult = result["account"] as? [String : AnyObject] {
                    
                    if let userID = accountResult["key"] as? String {
                        
                        self.userID = userID
                        
                    } else {
                        completionHandler(success: false, errorString: "LOGIN FAILED: could not find key 'key' in: \(accountResult)")
                    }
                } else {
                    completionHandler(success: false, errorString: "LOGIN FAILED: could not find key 'account' in: \(result)")
                }
                
                // made it here then success true
                completionHandler(success: true, errorString: nil)
            }
        })
    }
    
    /*
    ** logout from udacity, end udacity session
    */
    func deleteUdacitySession(completionHandler: (success: Bool, logoutResponse: String?, errorString: String?) -> Void) {
        
        taskForDELETEMethod(Client.Methods.UdacitySession, completionHandler: { (result, error) in
            
            if let error = error {
                print(error)
                completionHandler(success: false, logoutResponse: nil, errorString: "LOGOUT FAILED: failed to delete udacity session")
            } else {
                
                if let sessionResults = result["session"] as? [String : AnyObject] {
                    
                    if let sessionExpiration = sessionResults["expiration"] as? String {
                        
                        completionHandler(success: true, logoutResponse: "expiration date: \(sessionExpiration)", errorString: nil)
                        
                    } else {
                        completionHandler(success: false, logoutResponse: nil, errorString: "LOGOUT FAILED: could not find key 'expiration' in: \(result)")
                    }
                } else {
                    completionHandler(success: false, logoutResponse: nil, errorString: "LOGOUT FAILED: could not find key 'session' in: \(result)")
                }
            }
        })
    }
    
    /*
    ** get all student location objects
    */
    func getParseStudentLocationObjects(completionHandler: (students: [Student]?, errorString: String?) -> Void) {
        
        let baseURLString = Constants.ParseBaseURL
        let method = Methods.ParseStudentLocation
        let parameters = [String : AnyObject]()
        
        let httpHeader : [String : String] = [
            HTTPHeaderKeys.ParseApplicationIDKey : APIKeys.ParseApplicationID,
            HTTPHeaderKeys.ParseRESTApiKey : APIKeys.ParseRESTApiID
        ]
        
        taskForGETMethod(method, baseURLString: baseURLString, parameters: parameters, httpHeader: httpHeader, completionHandler: { (result, error) in
            
            if let error = error {
                print(error)
                completionHandler(students: nil, errorString: "ERROR: get student location objects failed")
            } else {
                
                if let results = result["results"] as? [[String : AnyObject]] {
                    
                    let students = Student.studentFromResults(results)
                    completionHandler(students: students, errorString: nil)
                    
                } else {
                    completionHandler(students: nil, errorString: "ERROR: could not find key 'results' in: \(result)")
                }
            }
        })
    }
    
    /*
    ** post student location object
    */
    func postParseStudentLocationObject(mapString: String, userURL: String, latitude: Double, longitude: Double, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let baseURLString = Client.Constants.ParseBaseURL
        let method = Client.Methods.ParseStudentLocation
        let parameters = [String : AnyObject]()
        
        let httpBody : [String : AnyObject!] = [
            Client.HTTPBodyKeys.ParseUniqueKey : self.userID,
            Client.HTTPBodyKeys.ParseFirstName : self.userFirstName,
            Client.HTTPBodyKeys.ParseLastName : self.userLastName,
            Client.HTTPBodyKeys.ParseMapString : mapString,
            Client.HTTPBodyKeys.ParseMediaURL : userURL,
            Client.HTTPBodyKeys.ParseLatitude : latitude,
            Client.HTTPBodyKeys.ParseLongitude : longitude
        ]
        
        let httpHeader : [String : String] = [
            Client.HTTPHeaderKeys.ParseContentType : "application/json",
            Client.HTTPHeaderKeys.ParseApplicationIDKey : Client.APIKeys.ParseApplicationID,
            Client.HTTPHeaderKeys.ParseRESTApiKey : Client.APIKeys.ParseRESTApiID
        ]
        
        taskForPOSTMethod(method, baseURLString: baseURLString, parameters: parameters, httpBody: httpBody, httpHeader: httpHeader, completionHandler: { (result, error) in
            
            if let error = error {
                print(error)
                completionHandler(success: false, errorString: "ERROR: failed to post student location object")
            } else {
                
                if let createdAt = result["createdAt"] as? String {
                    print("new Parse Student Location Object created at: \(createdAt)")
                    completionHandler(success: true, errorString: nil)
                } else {
                    completionHandler(success: false, errorString: "ERROR: could not find key 'createdAt' in: \(result)")
                }
            }
        })
    }
    
    
}