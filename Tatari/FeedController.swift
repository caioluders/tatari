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
    @IBOutlet weak var activityFeed: UIActivityIndicatorView!
    var items: [String] = ["We", "Heart", "Swift"]
    var itemsTitle: [String] = []
    var itemsBody: [String] = []
    lazy var data = NSMutableData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Avisos"
        self.tableView.separatorStyle = .None
        
        let bgImage = UIImage(named: "Background")
        self.tableView.backgroundView = UIImageView(image: bgImage)
        self.tableView.backgroundView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.activityFeed.startAnimating()
        self.activityFeed.hidesWhenStopped = true
        
        self.tableView.allowsSelection = false
        
        let mutable_result =  NSMutableDictionary()
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let fb_id = defaults.stringForKey("fb_id")
        
        mutable_result.setObject(FBSDKAccessToken.currentAccessToken().tokenString,forKey:"current_token")
        
        self.HTTPPostJSON("http://45.55.146.229:116/feed", jsonObj: mutable_result, callback: { (data,error) -> Void in
            let json = JSON(data: data.dataUsingEncoding(NSUTF8StringEncoding)!)
            for (wtf,object) in json {
                print(object["text"].stringValue) // Text of the update
                print(object["title"].stringValue) // Title of the update
                self.itemsTitle.append(object["title"].stringValue)
                self.itemsBody.append(object["text"].stringValue)
            }
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.tableView.reloadData()
                self.activityFeed.stopAnimating()
            }
            
        })
        
        mutable_result.setObject("1042704092427256",forKey:"fb_id")
        
        self.HTTPPostJSON("http://45.55.146.229:116/challs", jsonObj: mutable_result, callback: { (data,error) -> Void in
            let json = JSON(data: data.dataUsingEncoding(NSUTF8StringEncoding)!)
            for (wtf,object) in json {
                
                // mesma coisa de cima
                print(object["text"].stringValue) // Text of the update
                print(object["title"].stringValue) // Title of the update
//                self.itemsTitle.append(object["text"].stringValue)
//                self.itemsBody.append(object["text"].stringValue)
            }
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.tableView.reloadData()
                self.activityFeed.stopAnimating()
            }
            
        })
        
        let nib = UINib(nibName: "feedCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "feedcell")
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsTitle.count;
        //return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:FeedTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("feedcell")! as! FeedTableViewCell
        cell.lblTitle.text = self.itemsTitle[indexPath.row]
        cell.txtBody.text = self.itemsBody[indexPath.row]
        //cell.lblTitle.text = self.items[indexPath.row]
        
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
