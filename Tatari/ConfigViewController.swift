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

    @IBOutlet weak var pin_avatar: UIImageView!

    @IBOutlet weak var visi_control: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Rodina", size: 20)!]
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

}
