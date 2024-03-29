//
//  ViewController.swift
//  sensor-testing
//
//  Created by Marcel de Siqueira Campos Rebouças on 9/3/15.
//  Copyright (c) 2015 mscr. All rights reserved.
//

import UIKit

class ViewController: UIViewController,FBSDKLoginButtonDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            // User is already logged in, do work such as go to next view controller.
            print("wtf")
            getFBUserData()

        }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton() // add constrain
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }

    }
    
      
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        if ((error) != nil) {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email") {
                print(FBSDKAccessToken.currentAccessToken())
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name , picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    let resultdict = result as! NSMutableDictionary
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setValue(resultdict["id"] as! String, forKey: "fb_id")
                    defaults.setValue(resultdict["picture"]!["data"]!!["url"]!! as! String, forKey: "fb_avatar")
                    defaults.synchronize()
                    let mutable_result =  NSMutableDictionary(dictionary:resultdict)
                    mutable_result.setObject(FBSDKAccessToken.currentAccessToken().tokenString,forKey:"current_token")
                    
                    mutable_result.setObject("",forKey:"device_token")

                    var request = FBSDKGraphRequest(graphPath:"/me/friends", parameters: nil);
                    
                    request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                        if error == nil {
                            let result_dict = result as! NSDictionary!
                            let fbs_friends : NSMutableArray = []
                            for i in 0...Int((result_dict["data"]?.count)!)-1 {
                                let fb_c_id = result_dict["data"]![i]["id"]!
                                fbs_friends.addObject(fb_c_id!)
                            }
                            mutable_result.setObject(fbs_friends,forKey:"friends")
                            
                            self.HTTPPostJSON("http://45.55.146.229:116/user", jsonObj: mutable_result, callback: { (data,error) -> Void in
                                print(data)
                            })
                            
                            self.performSegueWithIdentifier("main_segue", sender: self)
                        } else {
                            print("Error Getting Friends \(error)");
                        }
                    }
                    
                    self.performSegueWithIdentifier("main_segue", sender: self)
                }
            })
        }
    }
    
    func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
        
        let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(rawValue: 0)
        
        
        if NSJSONSerialization.isValidJSONObject(value) {
            
            do{
                let data = try NSJSONSerialization.dataWithJSONObject(value, options: options)
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    return string as String
                }
            }catch {
                
                print("error")
                //Access error here
            }
            
        }
        return ""
        
    }
    
    func HTTPsendRequest(request: NSMutableURLRequest,
        callback: (String, String?) -> Void) {
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(
                request, completionHandler :
                {
                    data, response, error in
                    if error != nil {
                        callback("", (error!.localizedDescription) as String)
                    } else {
                        callback(
                            NSString(data: data!, encoding: NSUTF8StringEncoding) as! String,
                            nil
                        )
                    }
            })
            
            task.resume()
            
    }
    
    func HTTPPostJSON(url: String,
        jsonObj: AnyObject,
        callback: (String, String?) -> Void) {
            let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.HTTPMethod = "POST"
            request.addValue("application/json",
            forHTTPHeaderField: "Content-Type")
            let jsonString = JSONStringify(jsonObj)
            let data: NSData = jsonString.dataUsingEncoding(
                NSUTF8StringEncoding)!
            request.HTTPBody = data
            HTTPsendRequest(request,callback: callback)
    }
}

