//
//  SplashViewController.swift
//  TaxiUser
//
//  Created by AppOrio on 22/05/17.
//  Copyright © 2017 apporio. All rights reserved.
//

import UIKit
import SwiftyJSON
import GoogleMaps
import MapKit
import Firebase


class SplashViewController: UIViewController,CLLocationManagerDelegate,MainCategoryProtocol {
    
    //MARK: Instnces
    var locationManager = CLLocationManager()
    var timer:Timer!
    var RANDOMNO = String()
    var appupdateData: AppUpdateModel!
    
    //MARK: Outlets
    @IBOutlet weak var gettinglocationlabel: UILabel!

    //MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gettinglocationlabel.text = "getting location....".localized      
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        // locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        if(UserDefaults.standard.object(forKey: "PreferredLanguage") as! String == "en"){
            if GlobalVarible.languagecodeselectinmenu == 0{
                GlobalVarible.languagecode = "en"
                UserDefaults.standard.set("en", forKey: "PreferredLanguage")
                GlobalVarible.languageid = 1
                Language.language = Language(rawValue: "en")!

            }
        } else{
            if GlobalVarible.languagecodeselectinmenu == 0{
                UserDefaults.standard.set("es", forKey: "PreferredLanguage")   
                GlobalVarible.languagecode = "es"
                GlobalVarible.languageid = 2
                Language.language = Language(rawValue: "es")!

            }
        }
        // self.getCurrentAddress()
        ApiManager.sharedInstance.protocolmain_Catagory = self
        ApiManager.sharedInstance.AppUdateMethod(ApplicationVersion: GlobalVarible.appversion)
        /*if(NsUserDekfaultManager.SingeltionInstance.isloggedin()){  
            //self.getCurrentAddress()
            let userid = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyuserid)
            let UserDeviceKey = UserDefaults.standard.string(forKey: "device_key")
            let uniqueid =  UserDefaults.standard.string(forKey: "unique_number")
            ApiManager.sharedInstance.protocolmain_Catagory = self
            ApiManager.sharedInstance.UserDeviceId(USERID: userid!, USERDEVICEID: UserDeviceKey! , FLAG: "1",UNIQUEID: uniqueid!)       
            timer  = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(SplashViewController.myPerformeCode1), userInfo: nil, repeats: false)
                    
        } else{
           // self.getCurrentAddress()
          //  randomStringWithLength(len: 15)            
            timer  = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(SplashViewController.myPerformeCode), userInfo: nil, repeats: false)
 
        }*/
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   /* func randomStringWithLength (len : Int) -> NSString {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString : NSMutableString = NSMutableString(capacity: len)
        for i in 0 ... len - 1{
            //for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
            RANDOMNO = randomString as String
            //defaults.setObject(RANDOMNO, forKey: "unique_number")
             UserDefaults.standard.setValue(RANDOMNO, forKey:"unique_number")

        }
        return randomString

    }*/
    
  /*  func getCurrentAddress() {
      //  let locManager = CLLocationManager()
        let currentLocation = CLLocation()
        self.locationManager.requestAlwaysAuthorization()
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse){
            if let   currentLocation = self.locationManager.location {   
                reverseGeocodeCoordinate(coordinate: currentLocation.coordinate)
                
            }  
        }
    }*/
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            reverseGeocodeCoordinate(coordinate: location.coordinate)
            GlobalVarible.PickUpLat = String(location.coordinate.latitude)
            GlobalVarible.PickUpLng = String(location.coordinate.longitude)
            locationManager.stopUpdatingLocation()
            
        }
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D)  {    
        // 1
        let geocoder = GMSGeocoder()
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                //  print(address.lines)
                let lines = address.lines
                GlobalVarible.Pickuptext = lines!.joined(separator: "\n")
                print(GlobalVarible.Pickuptext)
                if let city = address.locality{
                    GlobalVarible.usercityname  = String(city)
                    
                }
                else{
                    GlobalVarible.usercityname = "Dummy City"
                    
                }
            }
        }
    }
    
    func myPerformeCode(timer : Timer) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let revealViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(revealViewController, animated:true, completion:nil)
        
    }
    
    func myPerformeCode1(timer : Timer) {
       /* let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let revealViewController:MapViewController = storyBoard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        self.present(revealViewController, animated:true, completion:nil)*/
        GlobalVarible.locationdidactive = 1
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextController: MapViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        if let window = self.view.window{
            window.rootViewController = nextController

        }
    }
    
    func showalert(message:String)  {
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title:   "Alert".localized, message:message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "ok".localized, style: .default) { (action) in }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true) { }
    
        })        
    }
    
    func onProgressStatus(value: Int) {
        if(value == 0 ){
            MBProgressHUD.hide(for: self.view, animated: true)

        }else if (value == 1){
            let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
            spinnerActivity.label.text = "Loading".localized
            spinnerActivity.detailsLabel.text = "Please Wait!!".localized
            spinnerActivity.isUserInteractionEnabled = false
            
        }
    }
    
    func onSuccessExecution(msg: String) {
        print("\(msg)")

    }
    
    func onerror(msg : String) {
        MBProgressHUD.hide(for: self.view, animated: true)
        self.showalert(message: msg)
                
    }
    
    func onSuccessParse(data: AnyObject) {   
        if (GlobalVarible.Api == "appupdateData") {
            self.appupdateData = data as! AppUpdateModel
            GlobalVarible.updatechecklater = self.appupdateData.appcheck!
            if(self.appupdateData.appcheck == 1){
                if(self.appupdateData.details?.iosUserMaintenanceMode == "1"){
                    let alert = UIAlertController(title: "", message: "App is under maintance.".localized, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Exit".localized, style: .default) { _ in
                        exit(0)

                    }
                    alert.addAction(action)
                    self.present(alert, animated: true){}
 
                } else{
                    let message: String = "New Version Available. Please update the app first.".localized
                    let alertController = UIAlertController(
                        title: "UPDATE AVAILABLE ".localized, // This gets overridden below.
                        message: message,
                        preferredStyle: .alert

                    )
                    let okAction = UIAlertAction(title: "Update App".localized, style: .cancel) { _ -> Void in 
                        GlobalVarible.rateApp(appId: "id1361918088") { success in }
                    
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                
                }
            } else if(self.appupdateData.appcheck == 2){
                if(self.appupdateData.details?.iosUserMaintenanceMode == "1"){
                    let alert = UIAlertController(title: "", message: "App is under maintance.".localized, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Exit".localized, style: .default) { _ in
                        exit(0)

                    }
                    alert.addAction(action)
                    self.present(alert, animated: true){}

                }else{
                    let refreshAlert = UIAlertController(title: "UPDATE AVAILABLE ".localized, message: "New Version Available. Please update the app.".localized, preferredStyle: UIAlertControllerStyle.alert)
                    refreshAlert.addAction(UIAlertAction(title: "Update App".localized, style: .default, handler: { (action: UIAlertAction!) in                        
                        GlobalVarible.rateApp(appId: "id1361918088") { success in }

                    }))
                    refreshAlert.addAction(UIAlertAction(title: "Later".localized, style: .default, handler: { (action: UIAlertAction!) in
                        if(NsUserDekfaultManager.SingeltionInstance.isloggedin()){
                            let userid = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyuserid)
                            let UserDeviceKey = UserDefaults.standard.string(forKey: "device_key")
                            let uniqueid =  UserDefaults.standard.string(forKey: "unique_number")
                            ApiManager.sharedInstance.protocolmain_Catagory = self
                            ApiManager.sharedInstance.UserDeviceId(USERID: userid!, USERDEVICEID: UserDeviceKey! , FLAG: "1",UNIQUEID: uniqueid!)
                            self.timer  = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(SplashViewController.myPerformeCode1), userInfo: nil, repeats: false)
                            
                        }
                        else{
                            self.timer  = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(SplashViewController.myPerformeCode), userInfo: nil, repeats: false)
                            
                        }
                    }))
                    present(refreshAlert, animated: true, completion: nil)
                }

            } else{
                if(self.appupdateData.details?.iosUserMaintenanceMode == "1"){
                    let alert = UIAlertController(title: "", message: "App is under maintance.".localized, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Exit".localized, style: .default) { _ in
                        exit(0)
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true){}

                }else{                
                    if(NsUserDekfaultManager.SingeltionInstance.isloggedin()){
                        let userid = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyuserid)
                        let UserDeviceKey = UserDefaults.standard.string(forKey: "device_key")
                        let uniqueid =  UserDefaults.standard.string(forKey: "unique_number")
                        ApiManager.sharedInstance.protocolmain_Catagory = self
                        ApiManager.sharedInstance.UserDeviceId(USERID: userid!, USERDEVICEID: UserDeviceKey! , FLAG: "1",UNIQUEID: uniqueid!)                    
                        timer  = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(SplashViewController.myPerformeCode1), userInfo: nil, repeats: false)

                    } else{
                        // self.getCurrentAddress()
                        //  randomStringWithLength(len: 15)
                        timer  = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(SplashViewController.myPerformeCode), userInfo: nil, repeats: false)
                    
                    }
                }
            }
        }  
    }
}
