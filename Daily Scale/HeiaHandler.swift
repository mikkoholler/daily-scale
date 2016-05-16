//
//  HeiaHandler.swift
//  Daily Scale
//
//  Created by Michael Holler on 10/05/16.
//  Copyright © 2016 Holler. All rights reserved.
//

import Foundation

class HeiaHandler {

    static let instance = HeiaHandler()
    
    let defaults = NSUserDefaults.standardUserDefaults()

    func saveToken(new:String) {
        defaults.setObject(new, forKey: "Token")
        print("Token saved.")
    }
    
    func getToken() -> String {
        var token = ""
        if let fetched = defaults.objectForKey("Token") as? String {
            token = fetched
            print("Got token.")
        }
        return token
    }

    func deleteToken() {
        defaults.removeObjectForKey("Token")
        print("Token deleted.")
    }

    func loginWith(user:String, passwd:String, completion: (Bool) -> ()) {
        var success = false
        let secret = Secret()
        let params = "grant_type=password&username=\(user)&password=\(passwd)&client_id=\(secret.clientid)&client_secret=\(secret.secret)"
        
        let request = NSMutableURLRequest()
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        request.URL = NSURL(string: "https://api.heiaheia.com/oauth/token")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            do {
                let statuscode = (response as! NSHTTPURLResponse).statusCode
                if (statuscode == 200) {
                    if let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject] {
                        if let token = jsonObject["access_token"] as? String {
                                self.saveToken(token)
                                success = true
                        }
                    }
                }
            } catch {
                print("Could not tokenize")
            }
            NSOperationQueue.mainQueue().addOperationWithBlock {
                completion(success)
            }
        }
        task.resume()
    }
    
    func login(completion: (String, Int?) -> ()) {
        let token = getToken()
        if (!token.isEmpty) {
            completion(token, 200)
        } else {
            
            let secret = Secret()
            let params = "grant_type=password&username=\(secret.username)&password=\(secret.passwd)&client_id=\(secret.clientid)&client_secret=\(secret.secret)"
            
            let request = NSMutableURLRequest()
            request.HTTPMethod = "POST"
            request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
            request.URL = NSURL(string: "https://api.heiaheia.com/oauth/token")
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
                do {
                    if (error != nil) {
                        completion("", error?.code)
                    } else {
                        // TODO: crashes with no internets
                        if let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject] {
                            if let token = jsonObject["access_token"] as? String {
                                NSOperationQueue.mainQueue().addOperationWithBlock {
                                    self.saveToken(token)
                                    completion(token, 200)
                                }
                            }
                        }
                    }
                } catch {
                    print("Could not tokenize")
                }
            }
            task.resume()
        }
    }
    
    func getWeights(completion: ([Weight], Int?) -> ()) {
        var feed = [Weight]()
        var statuscode = 400

        let request = NSMutableURLRequest()
        let params = "year=2016&page=1&per_page=100&access_token=\(getToken())"
        let components = NSURLComponents(string: "https://api.heiaheia.com/v2/items")
        components?.query = params
        
        request.HTTPMethod = "GET"
        request.URL = components?.URL
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            do {
                if let r = response as? NSHTTPURLResponse {
                    statuscode = r.statusCode
                    if (statuscode == 200) {
                        if let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? Array<[String:AnyObject]> {
                            feed = jsonObject
                                .filter { $0["kind"] as! String == "Weight" }
                                .map { (let item) -> Weight in
                                    return self.parse(item)
                                }
                        }
                    }
                } else {
                    statuscode = 400
                }
            } catch let e {
                print("Cannot \(e)")
                statuscode = 400
            }
  
            NSOperationQueue.mainQueue().addOperationWithBlock {
                completion(feed, statuscode)
            }
        }
        task.resume()
    }

    func parse(item: [String:AnyObject]) -> Weight {
        var weight = Weight()
       
        if let entry = item["entry"] as? [String:AnyObject] {
            if let date = entry["date"] as? String {
                weight.date = dateFromString(date)
            }
            if let value = entry["value"] as? Double {
                weight.kg = value
            }
        }
        return weight
    }

    func saveWeight(date:NSDate, weight:Double) {
        login() { (token) in
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let datestr = dateFormatter.stringFromDate(date)
            let weightstr = String(format: "%.1f", weight)
            
            let params = "access_token=\(token)&date=\(datestr)&value=\(weightstr)&notes=&private=true"
            let request = NSMutableURLRequest()
            request.HTTPMethod = "POST"
            request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
            request.URL = NSURL(string: "https://api.heiaheia.com/v2/weights")
 
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            }
            task.resume()
        }
    }

    func dateFromString(date: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateInFormat = dateFormatter.dateFromString(date)

        return dateInFormat!
    }
    


}