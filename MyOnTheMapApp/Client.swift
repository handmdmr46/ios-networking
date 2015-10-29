//
//  Client.swift
//  MyOnTheMapApp
//
//  Created by martin hand on 10/28/15.
//  Copyright © 2015 martin hand. All rights reserved.
//

import Foundation

class Client : NSObject {
    
    // MARK: propeerties
    var session : NSURLSession
    
    var sessionID : String? = nil
    var userID : String? = nil
    var userImageURL : String? = nil
    var userFirstName : String? = nil
    var userLastName : String? = nil
    var mapString : String = "Oregon City, OR"
    var latitude : Double = 45.421362
    var longitude : Double = -122.644190
    
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    func taskForGETMethod(method: String, baseURLString: String, parameters: [String : AnyObject], httpHeader: [String : String], completionHandler: (result: AnyObject!, error: String?) -> Void) -> NSURLSessionDataTask {
        
        let urlString = baseURLString + method + Client.escapedParameters(parameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        if httpHeader.count > 0 {
            for (headerKey, headerValue) in httpHeader {
                request.addValue("\(headerValue)", forHTTPHeaderField: "\(headerKey)")
            }
        }
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            guard (error == nil) else {
                completionHandler(result: nil, error: "there was an error in your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    completionHandler(result: nil, error: "Your request returned an invalid response! StatusCode: \(response.statusCode)")
                } else if let response = response {
                    completionHandler(result: nil, error: "Your request returned an invalid response! Response: \(response)")
                } else {
                    completionHandler(result: nil, error: "Your request returned an invalid response!")
                }
                return
            }
            
            guard let data = data else {
                completionHandler(result: nil, error: "there was no data returned in your request")
                return
            }
            
            if httpHeader.count > 0 { // Parse API
                Client.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            } else { // Udacity API
                let _data = data.subdataWithRange(NSMakeRange(5, data.length - 5)) // skip first five characters
                Client.parseJSONWithCompletionHandler(_data, completionHandler: completionHandler)
            }
        }
        
        task.resume()
        
        return task
    }
    
    func taskForGETImage(filePathURL: String, completionHandler: (imageData: NSData?, error: String?) -> Void) -> NSURLSessionDataTask {
        
        let url = NSURL(string: filePathURL)!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            guard (error == nil) else {
                completionHandler(imageData: nil, error: "There was an error in your response: \(error)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    completionHandler(imageData: nil, error: "Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    completionHandler(imageData: nil, error: "Your request returned an invalid response! Response: \(response)!")
                } else {
                    completionHandler(imageData: nil, error: "Your request returned an invalid response!")
                }
                return
            }
            
            guard let data = data else {
                completionHandler(imageData: nil, error: "No data was returned by the request!")
                return
            }
            
            completionHandler(imageData: data, error: nil)
        }
        
        task.resume()
        
        return task
    }
    
    func taskForPOSTMethod(method: String, baseURLString: String, parameters: [String : AnyObject], httpBody: [String : AnyObject], httpHeader: [String : String], completionHandler: (result: AnyObject!, error: String?) -> Void) -> NSURLSessionDataTask {
        
        let urlString = baseURLString + method + Client.escapedParameters(parameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        
        for (key, value) in httpHeader {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(httpBody, options: .PrettyPrinted) // set http body
        }
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            guard (error == nil) else {
                completionHandler(result: nil, error: "There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    completionHandler(result: nil, error: "Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    completionHandler(result: nil, error: "Your request returned an invalid response! Response: \(response)!")
                } else {
                    completionHandler(result: nil, error: "Your request returned an invalid response!")
                }
                return
            }
            
            guard let data = data else {
                completionHandler(result: nil, error: "No data was returned by the request!")
                return
            }
            
            if httpHeader.count > 2 { // Parse API
                Client.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            } else { // Udacity API
                let _data = data.subdataWithRange(NSMakeRange(5, data.length - 5)) // skip first five characters - see note from udacity api
                Client.parseJSONWithCompletionHandler(_data, completionHandler: completionHandler)
            }
        }
        
        task.resume()
        
        return task
    }
    
    func taskForDELETEMethod(method: String, completionHandler: (result: AnyObject!, error: String?) -> Void) -> NSURLSessionDataTask {
        
        let urlString = Constants.UdacityBaseURL + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "DELETE"
        
        var xsrfCookie: NSHTTPCookie? = nil
        
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
        for cookie in sharedCookieStorage.cookies as [NSHTTPCookie]! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            guard (error == nil) else {
                print("there was an error in your request: \(error)")
                completionHandler(result: nil, error: "\(error)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    completionHandler(result: nil, error: "Your request returned an invalid response! Status Code: \(response.statusCode)")
                } else if let response = response {
                    completionHandler(result: nil, error: "Your request returned an invalid response! Response: \(response)")
                } else {
                    completionHandler(result: nil, error: "Your request returned an invalid response!")
                }
                return
            }
            
            guard let data = data else {
                completionHandler(result: nil, error: "No data was returned in your request!")
                return
            }
            
            let _data = data.subdataWithRange(NSMakeRange(5, data.length - 5)) // skip first five characters - see note from udacity api
            
            Client.parseJSONWithCompletionHandler(_data, completionHandler: completionHandler)
        }
        
        task.resume()
        
        return task
    }
    
    // MARK: Helpers
    
    /* Helper: Substitute the key for the value that is contained within the method name */
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: String?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            completionHandler(result: nil, error: "Could not parse the data as JSON: '\(data)'")
        }
        
        completionHandler(result: parsedResult, error: nil)
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> Client {
        
        struct Singleton {
            static var sharedInstance = Client()
        }
        
        return Singleton.sharedInstance
    }
}