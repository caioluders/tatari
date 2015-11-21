//
//  DesafiosViewController.swift
//  Tatari
//
//  Created by Déborah Mesquita on 07/11/15.
//  Copyright © 2015 Caio Araújo. All rights reserved.
//

import UIKit

class DesafiosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var textArray: NSMutableArray! = NSMutableArray()
    var imageArray: NSMutableArray! = NSMutableArray()
    var fbIdDesafiado: String = ""
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.textArray.addObject("Beba uma lapada de cana!")
        self.textArray.addObject("Grite 'TOCA RUSH'")
        self.textArray.addObject("Elogie o bigode de alguém")
        self.textArray.addObject("Foto com uma das bandas")
        self.textArray.addObject("Crie uma dancinha")
        self.textArray.addObject("Texto só pra ver se a célula vai se ajustar ou não ao tamanho mesmo mesmo mesmo")
        
        self.imageArray.addObject(UIImage(named: "Dado 1")!)
        self.imageArray.addObject(UIImage(named: "Dado 2")!)
        self.imageArray.addObject(UIImage(named: "Dado 3")!)
        self.imageArray.addObject(UIImage(named: "Dado 4")!)
        self.imageArray.addObject(UIImage(named: "Dado 5")!)
        self.imageArray.addObject(UIImage(named: "Dado 5")!)
        
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cellDesafio", forIndexPath: indexPath)
        
        cell.textLabel?.text = self.textArray.objectAtIndex(indexPath.row) as! String
        cell.imageView?.image = self.imageArray.objectAtIndex(indexPath.row) as! UIImage
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.textArray.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.send_chall(self.fbIdDesafiado, challenge_desc: self.textArray.objectAtIndex(indexPath.row) as! NSString)
        print("mandou desafio para: ")
        print(self.fbIdDesafiado)
        dismissViewControllerAnimated(true, completion: nil)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
