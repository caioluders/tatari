//
//  VoteController.swift
//  Tatari
//
//  Created by Caio Araújo on 24/10/15.
//  Copyright © 2015 Caio Araújo. All rights reserved.
//

import UIKit

class VoteController: UIViewController, UITableViewDelegate, UITableViewDataSource , NSURLConnectionDelegate {

    @IBOutlet
    var tableView: UITableView!
    var items: [String] = ["We", "Heart", "Swift"]
    lazy var data = NSMutableData()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var bgImage = UIImage(named: "Background")
        self.tableView.backgroundView = UIImageView(image: bgImage)
        self.tableView.backgroundView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        var nib = UINib(nibName: "votoCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "votocell")
        
        var mutable_result =  NSMutableDictionary()
        mutable_result.setObject(FBSDKAccessToken.currentAccessToken().tokenString,forKey:"current_token")
        self.HTTPPostJSON("http://45.55.146.229:116/poll", jsonObj: mutable_result, callback: { (data,error) -> Void in
            let json = JSON(data: data.dataUsingEncoding(NSUTF8StringEncoding)!)
            for (wtf,object) in json {
                let imageData = NSData(base64EncodedString: object["img"].stringValue,options: NSDataBase64DecodingOptions(rawValue: 0))
                let image = UIImage(data: imageData!) // the image
                let desc = object["desc"].stringValue // the description
            }
        })
        
        vote_for(1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:VotoTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("votocell")! as! VotoTableViewCell
        
        cell.lblName.text = "Seketh Bárbara"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("oi")
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 430
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

    
    func vote_for(id:Int) {
        // Function for make the vote , use it with the didSelectRowAtIndexPath func
        
        // NAO TA FUNCIONANDO SA PORRA
        // SAD
        
        var mutable_result =  NSMutableDictionary()
        mutable_result.setObject(String(FBSDKAccessToken.currentAccessToken().tokenString),forKey:"current_token")
        
        var request = FBSDKGraphRequest(graphPath:"/me", parameters:["fields": "id"]);
        
        request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            if error == nil {
                mutable_result.setObject(result["id"] as! NSString,forKey:"fb_id")
                mutable_result.setObject(id,forKey:"id")
                print(mutable_result)
                self.HTTPPostJSON("http://45.55.146.229:116/poll", jsonObj: mutable_result, callback: { (data,error) -> Void in
                    print(data)
                })
            } else {
                print("Error Getting Friends \(error)");
            }
        }

       
    }

}
