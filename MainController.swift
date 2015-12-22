//
//  MainController.swift
//  Tatari
//
//  Created by Caio Araújo on 21/10/15.
//  Copyright © 2015 Caio Araújo. All rights reserved.
//

import UIKit
import CoreMotion
import MapKit
import CoreLocation

class MainController: UIViewController,CLLocationManagerDelegate,EILIndoorLocationManagerDelegate {

    @IBOutlet weak var map_indoor: EILIndoorLocationView!
    var sensorDataArray = [(String, String)]()
    let estimote_manager = EILIndoorLocationManager()
    var loc: EILLocation?
    
    // Accelerometer and Gyro
    var motionManager : CMMotionManager = CMMotionManager()
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Rodina", size: 20)!]
//        self.popupBar.hidden = true
//        self.popupMesa.hidden = true
//        self.popupPalco.hidden = true
//        self.popupBanheiroMasc.hidden = true
//        self.popupBanheiroFem.hidden = true
    }
    
//    @IBOutlet weak var popupBar: UIView!
//    @IBOutlet weak var popupMesa: UIView!
//    @IBOutlet weak var popupPalco: UIView!
//    @IBOutlet weak var popupBanheiroMasc: UIView!
//    @IBOutlet weak var popupBanheiroFem: UIView!
//    
//    @IBAction func btBar(sender: AnyObject) {
//        self.popupBar.hidden = !(self.popupBar.hidden)
//    }
//    
//    @IBAction func btMesa(sender: AnyObject) {
//        self.popupMesa.hidden = !(self.popupMesa.hidden)
//    }
//    
//    @IBAction func btPalco(sender: AnyObject) {
//        self.popupPalco.hidden = !(self.popupPalco.hidden)
//    }
//    
//    @IBAction func btBanheiroMasc(sender: AnyObject) {
//        self.popupBanheiroMasc.hidden = !(self.popupBanheiroMasc.hidden)
//    }
//   
//    @IBAction func btBanheiroFem(sender: AnyObject) {
//        self.popupBanheiroFem.hidden = !(self.popupBanheiroFem.hidden)
//    }
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Rodina", size: 20)!]
        
        
        // Location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()

        estimote_manager.delegate = self
        
        ESTConfig.setupAppID("caioluders-gmail-com-s-you-20y", andAppToken: "7ee5ad908110749b7786156ebe2dcc3f")
        
        let fetchLocationRequest = EILRequestFetchLocation(locationIdentifier: "auditorio-beps")
        
        fetchLocationRequest.sendRequestWithCompletion { (location, error) in
            if location != nil {
                self.loc = location!
                self.map_indoor.drawLocation(self.loc)
                self.estimote_manager.startPositionUpdatesForLocation(self.loc)
                var imageView = UIImageView(frame: CGRectMake(300, 300, 300, 300));
                var image = UIImage(named: "mapa_auditorio");
                imageView.image = image;
                let point = EILOrientedPoint.init(x: 0.0, y: 0.0, orientation: 300)
                
                self.map_indoor.drawObjectInForeground(imageView, withPosition: point, identifier: "mapa")
                self.map_indoor.showTrace = false
                self.map_indoor.showWallLengthLabels = false
                self.map_indoor.showBeacons = false

            } else {
                print("can't fetch location: \(error)")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        //self.navigationController?.navigationBarHidden = true
        // Accelerometer and Gyro
        motionManager.startAccelerometerUpdates()
        motionManager.startGyroUpdates()
        
        // Location
        locationManager.startUpdatingLocation()
        
        
        updateSensorDataArray()
        
        map_indoor.backgroundColor = UIColor.clearColor()
        map_indoor.showTrace = true
        map_indoor.showWallLengthLabels = true
        map_indoor.rotateOnPositionUpdate = false
        
        map_indoor.locationBorderColor = UIColor.blackColor()
        map_indoor.locationBorderThickness = 6
        map_indoor.doorColor = UIColor.brownColor()
        map_indoor.doorThickness = 5
        map_indoor.traceColor = UIColor.yellowColor()
        map_indoor.traceThickness = 2
        map_indoor.wallLengthLabelsColor = UIColor.blackColor()
    }
    
    override func viewWillDisappear(animated: Bool) {
        // Accelerometer and Gyro
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        
        // Location
        locationManager.stopUpdatingLocation()
        

    }
    
    func updateSensorDataArray() {
        
        sensorDataArray = [(String, String)]()
        
        sensorDataArray += getLocationData()
        sensorDataArray += getAccelerometerData()
        sensorDataArray += getGyroData()
        
    }
    
    func getLocationData() -> [(String, String)] {
        
        var locationData = [(String, String)]()
        
        // Check if the user allowed authorization
        if   (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways)
        {
            
            if let location = locationManager.location {
                locationData += [("Latitude", "\(location.coordinate.latitude)")]
                locationData += [("Longitude","\(location.coordinate.longitude)")]
            }
            
            
        }  else {
            locationData += [("Latitude","nope")]
            locationData += [("Longitude","nope")]
        }
        
        return locationData
    }
    
    func getAccelerometerData() -> [(String, String)] {
        
        var accelerometerData = [(String, String)]()
        
        if(motionManager.accelerometerData != nil)
        {
            let data = motionManager.accelerometerData
            
            accelerometerData += [("Accelerometer X", "\(data!.acceleration.x)")]
            accelerometerData += [("Accelerometer Y", "\(data!.acceleration.y)")]
            accelerometerData += [("Accelerometer Z", "\(data!.acceleration.z)")]
        } else {
            accelerometerData += [("Accelerometer X", "nope")]
            accelerometerData += [("Accelerometer Y", "nope")]
            accelerometerData += [("Accelerometer Z", "nope")]
        }
        
        
        return accelerometerData
    }
    
    func getGyroData() -> [(String, String)] {
        var gyroData = [(String, String)]()
        
        if(motionManager.gyroData != nil)
        {
            let data = motionManager.gyroData
            
            gyroData += [("Gyro X", "\(data!.rotationRate.x)")]
            gyroData += [("Gyro Y", "\(data!.rotationRate.y)")]
            gyroData += [("Gyro Z", "\(data!.rotationRate.z)")]
        } else {
            gyroData += [("Gyro X", "nope")]
            gyroData += [("Gyro Y", "nope")]
            gyroData += [("Gyro Z", "nope")]
        }
        
        
        return gyroData
    }
    
    lazy var locationManager: CLLocationManager! = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
        }()
    
    @IBAction func accuracyChanged(sender: UISegmentedControl) {
        let accuracyValues = [
            kCLLocationAccuracyBestForNavigation,
            kCLLocationAccuracyBest,
            kCLLocationAccuracyNearestTenMeters,
            kCLLocationAccuracyHundredMeters,
            kCLLocationAccuracyKilometer,
            kCLLocationAccuracyThreeKilometers]
        
        locationManager.desiredAccuracy = accuracyValues[sender.selectedSegmentIndex];
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = newLocation.coordinate
        
        sensorDataArray = [(String, String)]()
        
        sensorDataArray += getLocationData()
        sensorDataArray += getAccelerometerData()
        sensorDataArray += getGyroData()
        
        
        var url: String = "http://waho.io:116/send?lat="+(sensorDataArray[0].1 )+"&long="+sensorDataArray[1].1
        
        url += "&ac_y="+sensorDataArray[3].1+"&ac_x="+sensorDataArray[2].1+"&ac_z="+sensorDataArray[4].1
        
        url += "&gy_x="+sensorDataArray[5].1+"&gy_z="+sensorDataArray[7].1+"&gy_y="+sensorDataArray[6].1
        
        //url += "&mf_x="+sensorDataArray[8].1+"&mf_y="+sensorDataArray[9].1+"&mf_z="+sensorDataArray[10].1
        
        let url2 = NSURL(string:url)!
//        print(url)
        //        let url = NSURL(string: "http://waho.io/tatari")
        let request : NSURLRequest = NSURLRequest(URL: url2)
        _ = NSURLSession.sharedSession()
        let queue:NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            var _: NSError
        })
    }
    
    func indoorLocationManager(manager: EILIndoorLocationManager!,
        didFailToUpdatePositionWithError error: NSError!) {
            print("failed to update position: \(error)")
    }
    
    func indoorLocationManager(manager: EILIndoorLocationManager!,
        didUpdatePosition position: EILOrientedPoint!,
        withAccuracy positionAccuracy: EILPositionAccuracy,
        inLocation location: EILLocation!) {
            var accuracy: String!
            switch positionAccuracy {
            case .VeryHigh: accuracy = "+/- 1.00m"
            case .High:     accuracy = "+/- 1.62m"
            case .Medium:   accuracy = "+/- 2.62m"
            case .Low:      accuracy = "+/- 4.24m"
            case .VeryLow:  accuracy = "+/- ? :-("
            }
            print(String(format: "x: %5.2f, y: %5.2f, orientation: %3.0f, accuracy: %@",
                position.x, position.y, position.orientation, accuracy))
            
            self.map_indoor.updatePosition(position)
    }

}
