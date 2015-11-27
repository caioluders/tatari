//
//  SearchController.swift
//  Tatari
//
//  Created by Caio Araújo on 25/10/15.
//  Copyright © 2015 Caio Araújo. All rights reserved.
//

import UIKit

class SearchController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var activityLoadingSearch: UIActivityIndicatorView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtFieldSearch: UITextField!
    var people: [String] = []
    var imgPeople: [UIImage] = []
    var fbIds: [String] = []
    var dataPerson: [(String, UIImage, String)] = []
    var idsLikes: [String] = []
    var point : NSNumber = 0
    var fbIdDesafiado = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Rodina", size: 20)!]
        
        self.tableView.delegate = self
        let bgImage = UIImage(named: "Background")
        self.tableView.backgroundView = UIImageView(image: bgImage)
        self.tableView.backgroundView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.tableView.allowsSelection = false
        self.tableView.separatorStyle = .None
        
        self.activityLoadingSearch.hidesWhenStopped = true
        
        self.navigationItem.title = "Pessoas"
        self.tableView.allowsSelection = false
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
        self.activityLoadingSearch.startAnimating()
        search_people(txtFieldSearch.text!)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.txtFieldSearch.resignFirstResponder()
        return true;
    }
    
    func search_people(ssearch:NSString) -> Void {
        // Function to make the autocomplete search
        // uses the callback to get the result3
        var json: JSON = JSON([])
        
        var mutable_result =  NSMutableDictionary()
        self.people.removeAll()
        self.imgPeople.removeAll()
        self.fbIds.removeAll()
        self.dataPerson.removeAll()
        self.idsLikes.removeAll()
        mutable_result.setObject(FBSDKAccessToken.currentAccessToken().tokenString,forKey:"current_token")
        mutable_result.setObject(ssearch,forKey:"search")
        mutable_result.setObject(self.point,forKey:"pointer")
        
        self.HTTPPostJSON("http://45.55.146.229:116/search_people", jsonObj: mutable_result, callback: { (data,error) -> Void in
            json = JSON(data: data.dataUsingEncoding(NSUTF8StringEncoding)!)
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let idString = defaults.stringForKey("fb_id")
            
            var name = ""
            var fbId = ""
            var image: UIImage = UIImage()
            
            for (_,object) in json {
                let url = NSURL(string: object["picture"]["data"]["url"].stringValue)
                let data = NSData(contentsOfURL: url!)
                
                self.imgPeople.append(UIImage(data: data!)!)
                
                name = object["name"].stringValue
                fbId = object["id"].stringValue
                image = UIImage(data: data!)!
                
                if(!self.people.contains(name)){
                    self.people.append(object["name"].stringValue)
                    print(object["name"].stringValue)
                    self.fbIds.append(object["id"].stringValue)
                }
                
                //self.dataPerson.append((name,image,fbId))
                
                
                var likes: [String] = []
                for (_,id_like) in object["likes"]{
                    likes.append(id_like.stringValue)
                }
                
                if (likes.contains(idString!)){
                    print("hum, deu like")
                    self.idsLikes.append(fbId)
                }
            }
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.tableView.reloadData()
                self.activityLoadingSearch.stopAnimating()
            }
            print("DATA PERSON "+String(self.dataPerson.count))
            print(self.people.count)
            print(self.imgPeople.count)
            print(self.fbIds.count)
        })
        
        self.people = []
        self.imgPeople = []
        self.fbIds = []
        self.dataPerson = []
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRows")
        print(self.people.count)
        return self.people.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:personTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("personcell")! as! personTableViewCell
        
        cell.lblNome.text = self.people[indexPath.row]
        cell.imgPessoa.image = self.imgPeople[indexPath.row]
        cell.fbId = fbIds[indexPath.row]
        cell.btDesafiar.tag = indexPath.row
        cell.btDesafiar.addTarget(self, action: "buttonDesafiarAction:", forControlEvents: UIControlEvents.TouchUpInside)
        if(self.idsLikes.contains(fbIds[indexPath.row])){
            cell.btCurtir.setImage(UIImage(named: "Heart Full"), forState: UIControlState.Normal)
        }
        
        /**
        cell.borderView.layer.borderColor = UIColor(colorLiteralRed: 0.016, green: 0.063, blue: 0.271, alpha: 1).CGColor
        cell.borderView.layer.borderWidth = 3
        cell.borderView.layer.cornerRadius = 12
        
        cell.backgroundColor = UIColor.clearColor()
        **/
        
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Rodina", size: 20)!]
        self.activityLoadingSearch.startAnimating()
        search_people(txtFieldSearch.text!)
    }
    
    func showChallengeView(fbId: String){
        print("chamou "+fbId)
        //self.txtFieldSearch.enabled = false
        //var nextVC = DesafiosViewController()
        //self.navigationController?.pushViewController(nextVC, animated: true)
        self.performSegueWithIdentifier("oi", sender: nil)
    }
    
    func buttonDesafiarAction(sender:UIButton!){
        let alertController = UIAlertController(title: "Enviar desafio", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        let challenge1 = UIAlertAction(title: "Dê uma bebida pro mais gato(a)", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
            print("Challenge 1")
            var thisFbId = self.fbIds[sender.tag]
            print(thisFbId)
            self.send_chall(thisFbId, challenge_desc: "Dê uma bebida pro mais gato(a)")
        })
        alertController.addAction(challenge1)
        
        let challenge2 = UIAlertAction(title: "Vá ao bar se quiser um beijo", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
            print("Challenge 2")
            var thisFbId = self.fbIds[sender.tag]
            print(thisFbId)
            self.send_chall(thisFbId, challenge_desc: "Vá ao bar se quiser um beijo")
        })
        alertController.addAction(challenge2)
        
        let challenge3 = UIAlertAction(title: "Vire uma dose e grite 'AI PAPAI'!", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
            print("Challenge 3")
            var thisFbId = self.fbIds[sender.tag]
            print(thisFbId)
            self.send_chall(thisFbId, challenge_desc: "Vire uma dose e grite 'AI PAPAI'!")
        })
        alertController.addAction(challenge3)
        
        let challenge4 = UIAlertAction(title: "Mostre que vocé é top nos falsetes", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
            print("Challenge 4")
            var thisFbId = self.fbIds[sender.tag]
            print(thisFbId)
            self.send_chall(thisFbId, challenge_desc: "Mostre que vocé é top nos falsetes")
        })
        alertController.addAction(challenge4)
        
        let challenge5 = UIAlertAction(title: "Desce até o chão rodando", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
            print("Challenge 5")
            var thisFbId = self.fbIds[sender.tag]
            print(thisFbId)
            self.send_chall(thisFbId, challenge_desc: "Desce até o chão rodando")
        })
        alertController.addAction(challenge5)
        
        let cancelar = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel, handler: {(alert :UIAlertAction!) in
            print("Cancelar")
        })
        alertController.addAction(cancelar)
        
        //presentViewController(alertController, animated: true, completion: nil)
        self.fbIdDesafiado = self.fbIds[sender.tag]
        self.performSegueWithIdentifier("callChallengeTable", sender: self)
       
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "callChallengeTable" {
            var vc = segue.destinationViewController as! DesafiosViewController
            vc.fbIdDesafiado = self.fbIdDesafiado //you can do whatever you want with it in the 2nd VC
        }
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
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
