//
//  FeedController.swift
//  Tatari
//
//  Created by Caio Araújo on 24/10/15.
//  Copyright © 2015 Caio Araújo. All rights reserved.
//

import UIKit

class FeedController: UIViewController, UITableViewDelegate, UITableViewDataSource , NSURLConnectionDelegate {

    @IBOutlet
    var tableView: UITableView!
    var items: [String] = ["We", "Heart", "Swift"]
    lazy var data = NSMutableData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var mutable_result =  NSMutableDictionary()
        mutable_result.setObject(FBSDKAccessToken.currentAccessToken().tokenString,forKey:"current_token")
        self.HTTPPostJSON("http://45.55.146.229:116/feed", jsonObj: mutable_result, callback: { (data,error) -> Void in
            let json = JSON(data: data.dataUsingEncoding(NSUTF8StringEncoding)!)
            for (wtf,object) in json {
                print(object["text"].stringValue) // Text of the update
                print(object["title"].stringValue) // Title of the update
            }
        })
        var nib = UINib(nibName: "feedCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "feedcell")
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:FeedTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("feedcell")! as! FeedTableViewCell
        cell.lblTitle.text = self.items[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("oi")
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 170
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
