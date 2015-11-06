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
  
    var tableView: UITableView!
    @IBOutlet weak var activityVote: UIActivityIndicatorView!
    var items: [String] = ["We", "Heart", "Swift"]
    var pictures: [UIImage] = []
    var qtdVotes: [Int] = []
    var voted: [Int] = []
    var names: [String] = []
    var ids: [String] = []
    lazy var data = NSMutableData()
    var idBotaoVoto: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
               
        
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
        
        self.getDataFromServer()
    }
    
    func getDataFromServer(){
        self.cleanAllArrays()
        self.activityVote.startAnimating()
        let mutable_result =  NSMutableDictionary()
        mutable_result.setObject(FBSDKAccessToken.currentAccessToken().tokenString,forKey:"current_token")
        self.HTTPPostJSON("http://45.55.146.229:116/poll", jsonObj: mutable_result, callback: { (data,error) -> Void in
            var err:NSError?
            let json = JSON(data: data.dataUsingEncoding(NSUTF8StringEncoding)!,error:&err)
            print(err)
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let idString = defaults.stringForKey("fb_id")
            
            if(err == nil) {
                for (_,object) in json {
                    if ( object["img"].stringValue != "" ) {
                        let imageData = NSData(base64EncodedString: object["img"].stringValue,options: NSDataBase64DecodingOptions(rawValue: 0))
                        let image = UIImage(data: imageData!) // the image
                        let name = object["name"].stringValue
                        let id = object["id"].stringValue
                        var votes: [String] = []
                        for (_,id_vote) in object["votes"]{
                            votes.append(id_vote.stringValue)
                        }
                        let qtdVotesThisPic = Int(votes.count)
                        
                        if (votes.contains(idString!)){
                            print("já votou, querido")
                            self.idBotaoVoto = id
                        }
                        self.pictures.append(image!)
                        
                        self.names.append(name)
                        self.ids.append(id)
                        self.qtdVotes.append(qtdVotesThisPic)
                    }
                    
                }
                dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                    self.tableView.reloadData()
                    self.activityVote.stopAnimating()
                }
            }
        })
    
    }
    
    func cleanAllArrays(){
        self.pictures = []
        self.names = []
        self.ids = []
        self.qtdVotes = []
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btParticipar(sender: AnyObject) {

        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            var picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.mediaTypes = [kUTTypeImage as String]
            picker.allowsEditing = true
            self.presentViewController(picker, animated: true, completion: nil)
        }
        else{
            NSLog("No Camera.")
        }
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
            add_photo(imageToSave!)
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
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
        cell.lblVoteCount.text = String(self.qtdVotes[indexPath.row])
        cell.btVote.tag = Int(self.ids[indexPath.row])!
        
        if (self.ids[indexPath.row] == self.idBotaoVoto){
            cell.btVote.setImage(UIImage(named: "heart icon full"), forState:UIControlState.Normal)
        }
        
        return cell
    }
    
    func buttonVoteAction(sender:UIButton!)
    {
        vote_for(sender.tag)
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
    
        var imageData = UIImageJPEGRepresentation(img,0.5)
        let base64String = imageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        
        var mutable_result =  NSMutableDictionary()
        mutable_result.setObject(String(FBSDKAccessToken.currentAccessToken().tokenString),forKey:"current_token")
        
        mutable_result.setObject(base64String,forKey:"img")
        var request = FBSDKGraphRequest(graphPath:"/me", parameters:["fields": "id,name"]);
       
        request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            if error == nil {
                mutable_result.setObject(result["id"] as! NSString,forKey:"fb_id")
                mutable_result.setObject(result["name"] as! NSString,forKey:"name")
                self.HTTPPostJSON("http://45.55.146.229:116/new_photo", jsonObj: mutable_result, callback: { (data,error) -> Void in
                    //print(data)
                })
            } else {
                print("Error Getting Friends \(error)");
            }
            self.getDataFromServer()
        }

    }

}
