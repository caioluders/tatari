//
//  personTableViewCell.swift
//  Tatari
//
//  Created by Déborah Mesquita on 06/11/15.
//  Copyright © 2015 Caio Araújo. All rights reserved.
//

import UIKit

extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.sharedApplication()
        for url in urls {
            if application.canOpenURL(NSURL(string: url)!) {
                application.openURL(NSURL(string: url)!)
                return
            }
        }
    }
}

class personTableViewCell: UITableViewCell {

    @IBOutlet weak var imgPessoa: UIImageView!
    @IBOutlet weak var lblCurtir: UILabel!
    @IBOutlet weak var lblDesafiar: UILabel!
    @IBOutlet weak var lblFacebook: UILabel!
    @IBOutlet weak var btCurtir: UIButton!
    @IBOutlet weak var btFacebook: UIButton!
    @IBOutlet weak var btDesafiar: UIButton!
    @IBOutlet weak var lblNome: UILabel!
    
    var fbId = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func btFacebookPressed(sender: UIButton) {
        UIApplication.tryURL([
            "fb://profile/"+self.fbId, // App
            "http://www.facebook.com/"+self.fbId // Website if app fails
            ])
    }
    
    @IBAction func btDesafiarPressed(sender: UIButton) {
        print("desafiar")
        let searchVC = SearchController()       
        searchVC.showChallengePopUp(self.fbId)
        
    }
    
    @IBAction func btCurtirPressed(sender: AnyObject) {
        let mutable_result =  NSMutableDictionary()
        mutable_result.setObject(String(FBSDKAccessToken.currentAccessToken().tokenString),forKey:"current_token")
        mutable_result.setObject(self.fbId,forKey:"liked_fb_id")
        
        self.HTTPPostJSON("http://45.55.146.229:116/like", jsonObj: mutable_result, callback: { (data,error) -> Void in
            print(data)
        })
    }
    
    func send_chall(fb_id:NSString , challenge_desc:NSString) -> Void {
        let mutable_result =  NSMutableDictionary()
        mutable_result.setObject(String(FBSDKAccessToken.currentAccessToken().tokenString),forKey:"current_token")
        mutable_result.setObject(fb_id,forKey:"fb_id")
        mutable_result.setObject(challenge_desc,forKey:"challenge")
        
        self.HTTPPostJSON("http://45.55.146.229:116/new_challenge", jsonObj: mutable_result, callback: { (data,error) -> Void in
            print(data)
        })
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
