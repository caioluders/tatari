//
//  ConfigViewController.swift
//  Tatari
//
//  Created by Déborah Mesquita on 07/11/15.
//  Copyright © 2015 Caio Araújo. All rights reserved.
//

import Toucan
import UIKit

class ConfigViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var swt_all: UISwitch!
    @IBOutlet weak var swt_friends: UISwitch!
    @IBOutlet weak var swt_nobody: UISwitch!
    @IBOutlet weak var pin_avatar: UIImageView!
    @IBOutlet weak var constPickerToLogout: NSLayoutConstraint!
    @IBOutlet weak var constLegendaToPicker: NSLayoutConstraint!
    @IBOutlet weak var constVisibilidadeToPicker: NSLayoutConstraint!
    
    @IBOutlet weak var constPontosToVisibilidade: NSLayoutConstraint!
    @IBOutlet weak var contPinToVisibilidade: NSLayoutConstraint!
    
    @IBOutlet weak var constButtonToBotton: NSLayoutConstraint!
    @IBOutlet weak var picker: UIPickerView!
    var pickerData: [String] = [String]()
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Rodina", size: 20)!]
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        var height = screenSize.height
        
        if(height == 667){
            self.constButtonToBotton.constant = 90
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Rodina", size: 20)!]
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(colorLiteralRed: 0.016, green: 0.063, blue: 0.271, alpha: 1)]
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let avatar_url = NSURL(string: defaults.stringForKey("fb_avatar")!)
        let data = NSData(contentsOfURL: avatar_url!)
        let avatar_img = Toucan(image: UIImage(data: data!)!).resize(self.pin_avatar.image!.size, fitMode: Toucan.Resize.FitMode.Clip).image
        let maskingImage = Toucan(image: UIImage(named: "circle_mask.png")!).resize(self.pin_avatar.image!.size, fitMode: Toucan.Resize.FitMode.Clip).image
        
        self.pin_avatar.image = Toucan(image: avatar_img).maskWithImage(maskImage: maskingImage).image
        pickerData = ["Visível para todos", "Visível para amigos", "Visível para ninguém"]
        self.picker.delegate = self
        self.picker.dataSource = self
        

    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.blackColor()
        pickerLabel.text = self.pickerData[row]
        // pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15)
        pickerLabel.font = UIFont(name: "Gill Sans", size: 24) // In this use your custom font
        pickerLabel.sizeToFit()
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Send data about visibility to server
        
        let mutable_result =  NSMutableDictionary()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let fb_id = defaults.stringForKey("fb_id")
        
        mutable_result.setObject(FBSDKAccessToken.currentAccessToken().tokenString,forKey:"current_token")
        
        if ( row == 0 ) {
            mutable_result.setObject("all",forKey:"visibility")
        } else if ( row == 1 ) {
            mutable_result.setObject("friends",forKey:"visibility")
        } else if ( row == 2 ) {
            mutable_result.setObject("nope",forKey:"visibility")
        }
        
        self.HTTPPostJSON("http://45.55.146.229:116/change_settings", jsonObj: mutable_result, callback: { (data,error) -> Void in
            let json = JSON(data: data.dataUsingEncoding(NSUTF8StringEncoding)!)
        })

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
