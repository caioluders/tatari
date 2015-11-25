//
//  ConfigViewController.swift
//  Tatari
//
//  Created by Déborah Mesquita on 07/11/15.
//  Copyright © 2015 Caio Araújo. All rights reserved.
//

import Toucan
import UIKit

class ConfigViewController: UIViewController {

    @IBOutlet weak var swt_all: UISwitch!
    @IBOutlet weak var swt_friends: UISwitch!
    @IBOutlet weak var swt_nobody: UISwitch!
    @IBOutlet weak var pin_avatar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Rodina", size: 20)!]
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(colorLiteralRed: 0.016, green: 0.063, blue: 0.271, alpha: 1)]
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let avatar_url = NSURL(string: defaults.stringForKey("fb_avatar")!)
        let data = NSData(contentsOfURL: avatar_url!)
        let avatar_img = Toucan(image: UIImage(data: data!)!).resize(self.pin_avatar.image!.size, fitMode: Toucan.Resize.FitMode.Scale).image
        let maskingImage = Toucan(image: UIImage(named: "check3.png")!).resize(self.pin_avatar.image!.size, fitMode: Toucan.Resize.FitMode.Scale).image
        
        self.pin_avatar.image = Toucan(image: avatar_img).maskWithImage(maskImage: maskingImage).image

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btLogoutPressed(sender: AnyObject) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
    }

    
    func maskImage(image:UIImage, mask:(UIImage))->UIImage{
        
        let imageReference = image.CGImage
        let maskReference = mask.CGImage
        
        let imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference),
            CGImageGetHeight(maskReference),
            CGImageGetBitsPerComponent(maskReference),
            CGImageGetBitsPerPixel(maskReference),
            CGImageGetBytesPerRow(maskReference),
            CGImageGetDataProvider(maskReference), nil, true)
        
        let maskedReference = CGImageCreateWithMask(imageReference, imageMask)
        
        let maskedImage = UIImage(CGImage:maskedReference!)
        
        return maskedImage
    }

    @IBAction func swt_all_changed(sender: AnyObject) {
        if (self.swt_all.on == true ) {
            let mutable_result =  NSMutableDictionary()
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let fb_id = defaults.stringForKey("fb_id")
            
            mutable_result.setObject(FBSDKAccessToken.currentAccessToken().tokenString,forKey:"current_token")
            mutable_result.setObject("all",forKey:"visibility")
            
            self.HTTPPostJSON("http://45.55.146.229:116/change_settings", jsonObj: mutable_result, callback: { (data,error) -> Void in
                let json = JSON(data: data.dataUsingEncoding(NSUTF8StringEncoding)!)
            })
            
            self.swt_friends.on = true ;
            self.swt_nobody.on = false ;
        }
    }

    @IBAction func swt_friends_changed(sender: AnyObject) {
        if (self.swt_friends.on == true ) {
            let mutable_result =  NSMutableDictionary()
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let fb_id = defaults.stringForKey("fb_id")
            
            self.swt_all.on = true
            self.swt_nobody.on = false
            
            mutable_result.setObject(FBSDKAccessToken.currentAccessToken().tokenString,forKey:"current_token")
            mutable_result.setObject("friends",forKey:"visibility")
            
            self.HTTPPostJSON("http://45.55.146.229:116/change_settings", jsonObj: mutable_result, callback: { (data,error) -> Void in
                let json = JSON(data: data.dataUsingEncoding(NSUTF8StringEncoding)!)
            })
        }
    }
    @IBAction func swt_nobody_changed(sender: AnyObject) {
        if (self.swt_nobody.on == true ) {
            let mutable_result =  NSMutableDictionary()
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let fb_id = defaults.stringForKey("fb_id")
            
            mutable_result.setObject(FBSDKAccessToken.currentAccessToken().tokenString,forKey:"current_token")
            mutable_result.setObject("nope",forKey:"visibility")
            
            self.HTTPPostJSON("http://45.55.146.229:116/change_settings", jsonObj: mutable_result, callback: { (data,error) -> Void in
                let json = JSON(data: data.dataUsingEncoding(NSUTF8StringEncoding)!)
            })
            
            self.swt_all.on = false
            self.swt_friends.on = false
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
