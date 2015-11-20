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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var items: [String] = ["We", "Heart", "Swift"]
    var itemsTitle: [String] = []
    var itemsBody: [String] = []
    var arrayOfMessages = Array<Dictionary<String, String>>()
    var arraySorted = Array<Dictionary<String, String>>()
    var messageDict = Dictionary<String, String>()
    var challengeDict = Dictionary<String, String>()
    var point : Int = 0
    var loadingData = false
    lazy var data = NSMutableData()
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Avisos"
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Rodina", size: 20)!]
        
        //self.tableView.separatorStyle = .None
        self.tableView.separatorColor = UIColor(patternImage: UIImage(named: "Pontos")!)
        //self.tableView.estimatedRowHeight = 150.0
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 330.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        let bgImage = UIImage(named: "Background")
        self.tableView.backgroundView = UIImageView(image: bgImage)
        self.tableView.backgroundView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.tableView.allowsSelection = false
        
        self.activityFeed.startAnimating()
        self.activityFeed.hidesWhenStopped = true       
        
        
        self.refreshControl = UIRefreshControl()
        self.tableView.addSubview(refreshControl)
        self.refreshControl.addTarget(self, action: Selector("refresh_feed"), forControlEvents: UIControlEvents.ValueChanged)
        
        load_feed()
        
        let nib = UINib(nibName: "feedCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "feedcell")
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func computeCellHeight(cell_height: CGFloat, indexArray: Int){
        self.arraySorted[indexArray]["cell_height"] = String(cell_height)
        print(self.arraySorted[indexArray]["cell_height"])
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arraySorted.count;
        //return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:FeedTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("feedcell")! as! FeedTableViewCell
        cell.lblTitle.text = self.arraySorted[indexPath.row]["title"]
        cell.txtBody.text = self.arraySorted[indexPath.row]["body"]
        
        var messageTagType: String
        messageTagType = String(self.arraySorted[indexPath.row]["tag"])
        if (messageTagType == "desafio"){
            cell.imgMessageTagType.image = UIImage(named: "DesafioCellIcon")
        }else if(messageTagType == "like"){
            cell.imgMessageTagType.image = UIImage(named: "LikeCellIcon")
        }else{
            cell.imgMessageTagType.image = UIImage(named: "OrganizadorCellIcon")
        }
        /**
        cell.cnstHeightBorderView.constant = cell.txtBody.frame.height + 70
        print(cell.cnstHeightBorderView.constant )
        cell.borderView.layer.borderColor = UIColor.blackColor().CGColor
        cell.borderView.layer.borderWidth = 1
        cell.borderView.layer.cornerRadius = 12
        **/
//
//        let cell_height = cell.txtBody.frame.height + 140
//        self.computeCellHeight(cell_height, indexArray: indexPath.row)
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if !loadingData && indexPath.row == 15 - 1 {
            load_feed()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("oi")
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        var height: CGFloat = 0
//        if (self.arraySorted.count > 0) {
//            let heightString :String = self.arraySorted[indexPath.row]["cell_height"]!
//            if let n = NSNumberFormatter().numberFromString(heightString) {
//                height = CGFloat(n)
//            }
//        }
//        
//        return height
//    }
    
//    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//            return UITableViewAutomaticDimension
//    }
    
    
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
    
    func load_feed(cfrc:Bool = false) {
        
        let mutable_result =  NSMutableDictionary()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let fb_id = defaults.stringForKey("fb_id")
        
        mutable_result.setObject(FBSDKAccessToken.currentAccessToken().tokenString,forKey:"current_token")
        mutable_result.setObject(self.point,forKey:"pointer")
        
        self.HTTPPostJSON("http://45.55.146.229:116/feed", jsonObj: mutable_result, callback: { (data,error) -> Void in
            let json = JSON(data: data.dataUsingEncoding(NSUTF8StringEncoding)!)
            for (_,object) in json {
                
                print(object)
                self.messageDict["title"] = object["title"].stringValue
                self.messageDict["body"] = object["text"].stringValue
                self.messageDict["id"] = object["_id"]["$oid"].stringValue
                
                self.arrayOfMessages.append(self.messageDict)
            }
            
            //Show newest messages first
            
            self.arraySorted = self.arrayOfMessages.sort() {
                (dictOne, dictTwo) -> Bool in
                let d1 = dictOne["id"]! as String;
                let d2 = dictTwo["id"]! as String;
                
                return d1 > d2
                
            };
            
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.tableView.reloadData()
                self.activityFeed.stopAnimating()
                self.point = self.point+15
            }
            
        })
        
        mutable_result.setObject(fb_id!,forKey:"fb_id")
        
        self.HTTPPostJSON("http://45.55.146.229:116/challs", jsonObj: mutable_result, callback: { (data,error) -> Void in
            let json = JSON(data: data.dataUsingEncoding(NSUTF8StringEncoding)!)
            for (_,object) in json {
                
                self.challengeDict["title"] = object["title"].stringValue
                self.challengeDict["body"] = object["text"].stringValue
                self.challengeDict["id"] = object["_id"]["$oid"].stringValue
                
                self.arrayOfMessages.append(self.challengeDict)
            }
            
            self.arraySorted = self.arrayOfMessages.sort() {
                (dictOne, dictTwo) -> Bool in
                let d1 = dictOne["id"]! as String;
                let d2 = dictTwo["id"]! as String;
                
                return d1 > d2
                
            };
            
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.tableView.reloadData()
                self.activityFeed.stopAnimating()
            }
            
        })
    }
    
    func refresh_feed() {
    
        self.point = 0
        
        self.arrayOfMessages.removeAll()
        
        let mutable_result =  NSMutableDictionary()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let fb_id = defaults.stringForKey("fb_id")
        
        mutable_result.setObject(FBSDKAccessToken.currentAccessToken().tokenString,forKey:"current_token")
        mutable_result.setObject(self.point,forKey:"pointer")
        
        self.HTTPPostJSON("http://45.55.146.229:116/feed", jsonObj: mutable_result, callback: { (data,error) -> Void in
            let json = JSON(data: data.dataUsingEncoding(NSUTF8StringEncoding)!)
            for (_,object) in json {
                
                print(object)
                self.messageDict["title"] = object["title"].stringValue
                self.messageDict["body"] = object["text"].stringValue
                self.messageDict["id"] = object["_id"]["$oid"].stringValue
                
                self.arrayOfMessages.append(self.messageDict)
            }
            
            //Show newest messages first
            
            self.arraySorted = self.arrayOfMessages.sort() {
                (dictOne, dictTwo) -> Bool in
                let d1 = dictOne["id"]! as String;
                let d2 = dictTwo["id"]! as String;
                
                return d1 > d2
                
            };
            
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.tableView.reloadData()
                self.activityFeed.stopAnimating()
                self.point = self.point+15
            }
            
        })
        
        mutable_result.setObject(fb_id!,forKey:"fb_id")
        
        self.HTTPPostJSON("http://45.55.146.229:116/challs", jsonObj: mutable_result, callback: { (data,error) -> Void in
            let json = JSON(data: data.dataUsingEncoding(NSUTF8StringEncoding)!)
            for (_,object) in json {
                
                self.challengeDict["title"] = object["title"].stringValue
                self.challengeDict["body"] = object["text"].stringValue
                self.challengeDict["id"] = object["_id"]["$oid"].stringValue
                
                self.arrayOfMessages.append(self.challengeDict)
            }
            
            self.arraySorted = self.arrayOfMessages.sort() {
                (dictOne, dictTwo) -> Bool in
                let d1 = dictOne["id"]! as String;
                let d2 = dictTwo["id"]! as String;
                
                return d1 > d2
                
            };
            
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.tableView.reloadData()
                self.activityFeed.stopAnimating()
            }
            
        })
        self.refreshControl.endRefreshing()
    }
}
