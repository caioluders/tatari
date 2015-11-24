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

    @IBOutlet weak var pin_avatar: UIImageView!

    @IBOutlet weak var visi_control: UISegmentedControl!
    
    @IBOutlet weak var picker: UIPickerView!
    var pickerData: [String] = [String]()
    
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
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Send data about visibility to server
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

}
