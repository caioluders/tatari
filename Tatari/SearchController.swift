//
//  SearchController.swift
//  Tatari
//
//  Created by Caio Araújo on 25/10/15.
//  Copyright © 2015 Caio Araújo. All rights reserved.
//

import UIKit

class SearchController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

  
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtFieldSearch: UITextField!
    var people: [String] = []
    var imgPeople: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        
        self.navigationItem.title = "Pessoas"
        txtFieldSearch.delegate = self
        txtFieldSearch.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        // send_chall("708388879297355", challenge_desc: "Beba mais!")
        
        let nib = UINib(nibName: "personCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "personcell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldDidChange(textField: UITextField) {
        search_people(txtFieldSearch.text!)
    }
    
    func search_people(ssearch:NSString) -> Void {
        // Function to make the autocomplete search
        // uses the callback to get the result
        
        var json: JSON = JSON([])
        
        var mutable_result =  NSMutableDictionary()
        mutable_result.setObject(FBSDKAccessToken.currentAccessToken().tokenString,forKey:"current_token")
        mutable_result.setObject(ssearch,forKey:"search")
        self.HTTPPostJSON("http://45.55.146.229:116/search_people", jsonObj: mutable_result, callback: { (data,error) -> Void in
            json = JSON(data: data.dataUsingEncoding(NSUTF8StringEncoding)!)
            for (wtf,object) in json {
                self.people.append(object["name"].stringValue)
                self.imgPeople.append(object["picture"]["data"]["url"].stringValue)
            }
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.tableView.reloadData()
            }
            print(json)
            print(self.people.count)
        })
        self.people = []
        self.imgPeople = []
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.people.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:personTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("personcell")! as! personTableViewCell
        
        cell.lblNome.text = self.people[indexPath.row]
        
        let url = NSURL(string: self.imgPeople[indexPath.row])
        let data = NSData(contentsOfURL: url!)
        cell.imgPessoa.image = UIImage(data: data!)
        cell.btDesafiar.addTarget(self, action: "buttonDesafiarAction:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.btCurtir.addTarget(self, action: "buttonCurtirAction:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.btFacebook.addTarget(self, action: "buttonFacebookAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    func buttonDesafiarAction(sender:UIButton!){
        let alertController = UIAlertController(title: "Enviar desafio", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        let challenge1 = UIAlertAction(title: "Dê uma bebida pro mais gato(a)", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
            print("OK button tapped")
        })
        alertController.addAction(challenge1)
        
        let challenge2 = UIAlertAction(title: "Vá ao bar se quiser um beijo", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
            print("OK button tapped")
        })
        alertController.addAction(challenge2)
        
        let challenge3 = UIAlertAction(title: "Vire uma dose e grite 'AI PAPAI'!", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
            print("OK button tapped")
        })
        alertController.addAction(challenge3)
        
        let challenge4 = UIAlertAction(title: "Mostre que vocé é top nos falsetes", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
            print("OK button tapped")
        })
        alertController.addAction(challenge4)
        
        let challenge5 = UIAlertAction(title: "Desce até o chão rodando", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
            print("OK button tapped")
        })
        alertController.addAction(challenge5)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func buttonCurtirAction(sender:UIButton!){
        print("curtir")
    }
    
    func buttonFacebookAction(sender:UIButton!){
        print("facebook")
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
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
    
    func send_chall(fb_id:NSString , challenge_desc:NSString) -> Void {
        let mutable_result =  NSMutableDictionary()
        mutable_result.setObject(String(FBSDKAccessToken.currentAccessToken().tokenString),forKey:"current_token")
        mutable_result.setObject(fb_id,forKey:"fb_id")
        mutable_result.setObject(challenge_desc,forKey:"challenge")
        
        self.HTTPPostJSON("http://45.55.146.229:116/new_challenge", jsonObj: mutable_result, callback: { (data,error) -> Void in
            print(data)
        })
    }
}
