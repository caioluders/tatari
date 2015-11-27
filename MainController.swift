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

class MainController: UIViewController,CLLocationManagerDelegate {

    var sensorDataArray = [(String, String)]()
    
    // Accelerometer and Gyro
    var motionManager : CMMotionManager = CMMotionManager()
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Rodina", size: 20)!]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Rodina", size: 20)!]
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(colorLiteralRed: 0.016, green: 0.063, blue: 0.271, alpha: 1)]

        // Location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
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
        
        // Magnetometer
        motionManager.startMagnetometerUpdates()
        
        // Location
        locationManager.startUpdatingLocation()
        
        
        updateSensorDataArray()
    }
    
    override func viewWillDisappear(animated: Bool) {
        // Accelerometer and Gyro
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        
        // Magnetometer
        motionManager.stopMagnetometerUpdates()
        
        // Location
        locationManager.stopUpdatingLocation()

    }
    
    func updateSensorDataArray() {
        
        sensorDataArray = [(String, String)]()
        
        sensorDataArray += getLocationData()
        sensorDataArray += getAccelerometerData()
        sensorDataArray += getGyroData()
        sensorDataArray += getMagnetometerData()
        
    }
    
    func getMagnetometerData() -> [(String, String)]{
        var magnetometerData = [(String , String)]()
        
        if(motionManager.magnetometerData != nil)
        {
            let data = motionManager.magnetometerData
            
            magnetometerData += [("MagnetctField x" , "\(data!.magneticField.x)")]
            magnetometerData += [("MagnetctField y" , "\(data!.magneticField.y)")]
            magnetometerData += [("MagnetctField z" , "\(data!.magneticField.z)")]
        } else {
            magnetometerData += [("MagnetctField x" , "nope")]
            magnetometerData += [("MagnetctField y" , "nope")]
        }
        
        return magnetometerData
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
        sensorDataArray += getMagnetometerData()
        
        
        var url: String = "http://waho.io:116/send?lat="+(sensorDataArray[0].1 )+"&long="+sensorDataArray[1].1
        
        url += "&ac_y="+sensorDataArray[3].1+"&ac_x="+sensorDataArray[2].1+"&ac_z="+sensorDataArray[4].1
        
        url += "&gy_x="+sensorDataArray[5].1+"&gy_z="+sensorDataArray[7].1+"&gy_y="+sensorDataArray[6].1
        
        //url += "&mf_x="+sensorDataArray[8].1+"&mf_y="+sensorDataArray[9].1+"&mf_z="+sensorDataArray[10].1
        
        let url2 = NSURL(string:url)!
        print(url)
        //        let url = NSURL(string: "http://waho.io/tatari")
        let request : NSURLRequest = NSURLRequest(URL: url2)
        let session = NSURLSession.sharedSession()
        let queue:NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            var err: NSError
        })
    }

}
