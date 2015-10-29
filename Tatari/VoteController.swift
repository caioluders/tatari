//
//  VoteController.swift
//  Tatari
//
//  Created by Caio Araújo on 24/10/15.
//  Copyright © 2015 Caio Araújo. All rights reserved.
//

import UIKit
import MobileCoreServices

class VoteController: UIViewController, UITableViewDelegate, UITableViewDataSource , NSURLConnectionDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker: UIImagePickerController!
    

    @IBAction func btParticipar(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            print("Button capture")
            
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
//        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
//            var picker = UIImagePickerController()
//            picker.delegate = self
//            picker.sourceType = UIImagePickerControllerSourceType.Camera
//            picker.mediaTypes = [kUTTypeImage as String]
//            picker.allowsEditing = true
//            self.presentViewController(picker, animated: true, completion: nil)
//        }
//        else{
//            NSLog("No Camera.")
//        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        var originalImage:UIImage?, editedImage:UIImage?, imageToSave:UIImage?
        let compResult:CFComparisonResult = CFStringCompare(mediaType as NSString!, kUTTypeImage, CFStringCompareFlags.CompareCaseInsensitive)
        if ( compResult == CFComparisonResult.CompareEqualTo ) {
            
            editedImage = info[UIImagePickerControllerEditedImage] as! UIImage?
            originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage?
            
            if ( editedImage != nil ) {
                imageToSave = editedImage
            } else {
                imageToSave = originalImage
            }
            //Do stuff with imgView.image (send to server)
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
        print("hum")
    }
    
    
    var tableView: UITableView!
    @IBOutlet weak var activityVote: UIActivityIndicatorView!
    var items: [String] = ["We", "Heart", "Swift"]
    var pictures: [UIImage] = []
    var names: [String] = []
    var ids: [String] = []
    lazy var data = NSMutableData()
    var votou: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var image : UIImage = UIImage(named:"bar")!
        add_photo(image) // EXEMPLO DE USO !!!! PEGUE A IMG , JOGUE LA , PRONTO
        
        
        self.navigationItem.title = "Concurso de Fantasias"
        self.tableView.separatorStyle = .None
        
        self.activityVote.startAnimating()
        self.activityVote.hidesWhenStopped = true
        
        self.tableView.allowsSelection = false
        
        let bgImage = UIImage(named: "Background")
        self.tableView.backgroundView = UIImageView(image: bgImage)
        self.tableView.backgroundView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        let nib = UINib(nibName: "votoCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "votocell")
        
        let mutable_result =  NSMutableDictionary()
        mutable_result.setObject(FBSDKAccessToken.currentAccessToken().tokenString,forKey:"current_token")
        self.HTTPPostJSON("http://45.55.146.229:116/poll", jsonObj: mutable_result, callback: { (data,error) -> Void in
            let json = JSON(data: data.dataUsingEncoding(NSUTF8StringEncoding)!)
            for (wtf,object) in json {
                let imageData = NSData(base64EncodedString: object["img"].stringValue,options: NSDataBase64DecodingOptions(rawValue: 0))
                let image = UIImage(data: imageData!) // the image
                self.pictures.append(image!)
                self.names.append("Seketh Scharnhorst")
                self.ids.append(object["id"].stringValue)
                //let desc = object["desc"].stringValue // the description
            }
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.tableView.reloadData()
                self.activityVote.stopAnimating()
            }
        })
        
        //vote_for(1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pictures.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:VotoTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("votocell")! as! VotoTableViewCell
        
        cell.lblName.text = self.names[indexPath.row]
        cell.imgPerson.image = self.pictures[indexPath.row]
        cell.btVote.tag = indexPath.row
        cell.btVote.addTarget(self, action: "buttonVoteAction:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.lblVoteCount.text = "0"
        cell.btVote.tag = Int(self.ids[indexPath.row])!
        
        if (self.votou == true){
            cell.btVote.setImage(UIImage(named: "heart icon full"), forState:UIControlState.Normal)
        }
        
        return cell
    }
    
    func buttonVoteAction(sender:UIButton!)
    {
        vote_for(sender.tag)
        self.votou = true
        self.tableView.reloadData()
        print("votou "+String(sender.tag))
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
    
    func add_photo(img:UIImage) {
    
        var imageData = UIImagePNGRepresentation(img)
        let base64String = imageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        
        var mutable_result =  NSMutableDictionary()
        mutable_result.setObject(String(FBSDKAccessToken.currentAccessToken().tokenString),forKey:"current_token")
        mutable_result.setObject(base64String,forKey:"img")
        var request = FBSDKGraphRequest(graphPath:"/me", parameters:["fields": "id,name"]);
        
        request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            if error == nil {
                mutable_result.setObject(result["id"] as! NSString,forKey:"fb_id")
                mutable_result.setObject(result["name"] as! NSString,forKey:"name")
                print(mutable_result)
                self.HTTPPostJSON("http://45.55.146.229:116/new_photo", jsonObj: mutable_result, callback: { (data,error) -> Void in
                    print(data)
                })
            } else {
                print("Error Getting Friends \(error)");
            }
        }

    }

}
