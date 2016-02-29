//
//  VotoTableViewCell.swift
//  Tatari
//
//  Created by Déborah Mesquita on 27/10/15.
//  Copyright © 2015 Caio Araújo. All rights reserved.
//

import UIKit

class VotoTableViewCell: UITableViewCell {

    @IBOutlet weak var lblVoteCount: UILabel!
    @IBOutlet weak var btVote: UIButton!
    @IBOutlet weak var imgPerson: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btReport: UIButton!
    
    var fbId = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btVotePressed(sender: AnyObject) {
        self.btVote.setImage(UIImage(named: "heart icon full"), forState:UIControlState.Normal)
        print("preencheu o coração")
    }

    @IBAction func btReportPressed(sender: AnyObject) {
        let mutable_result =  NSMutableDictionary()
        mutable_result.setObject(String(FBSDKAccessToken.currentAccessToken().tokenString),forKey:"current_token")
        mutable_result.setObject(self.lblName.text! ,forKey:"name")
        
        self.HTTPPostJSON("http://45.55.146.229:116/report_vote", jsonObj: mutable_result, callback: { (data,error) -> Void in
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
