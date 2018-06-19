//
//  AppDelegate.swift
//  TaxiUser
//
//  Created by AppOrio on 20/05/17.
//  Copyright © 2017 apporio. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import UserNotifications
import Firebase
import Stripe
import FirebaseCore
import FirebaseCrash
import GoogleSignIn
import FacebookLogin
import FacebookCore
import CoreData
import FBSDKShareKit
import FBSDKLoginKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate,MainCategoryProtocol, CLLocationManagerDelegate {
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    
     var appupdateData: AppUpdateModel!

    
    var locationManager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
           
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            // If authorized when in use
          
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            // If always authorized
           
            manager.startUpdatingLocation()
            break
        case .restricted:
            // If restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // If user denied your app access to Location Services, but can grant access from Settings.app
            break
            
        }
    }

    

    var window: UIWindow?
    var part1: String = ""
    var part2: String = ""
    var part3: String = ""
  //  var mydata: DriverInfo!
    
   
    
    var customersyncdata: CustomerSyncModel!
    
    var rentalridesyncdata: RentalRideSyncModel!
    
   // var locationManager = CLLocationManager()



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            GlobalVarible.appversion = version
            debugPrint(version)
        }
        
        IQKeyboardManager.sharedManager().enable = true
        
        //        var configureError:NSError?
        //        CVEAGLContext.
        //        GGLContext.sharedInstance().configureWithError(&configureError)
        GIDSignIn.sharedInstance().clientID = "257963408968-0ijhr1miq4rm3034iccj1aru1iacv2fh.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
      
        
         FIRApp.configure()
        
        
        
         let device_id = UIDevice.current.identifierForVendor?.uuidString
        
        UserDefaults.standard.setValue(device_id, forKey:"unique_number")
        
      //  NSUserDefaults.standardUserDefaults().setObject(device_id, forKey: "DeviceId")
        
        ////Google...Map..Api...Key...
        GMSServices.provideAPIKey("AIzaSyC8nvP8ZzZJmo08reyuCP2ucd3f9g1wyYM")
        GMSPlacesClient.provideAPIKey("AIzaSyDcerhRQNc1zh9mWHX8S2kznEj8kfBO7kM")
        
       // AIzaSyDdN4fqXPnnGWuCs2d5ncpDBnGgKfDo1fM
        
        
       // GMSPlacesClient.provideAPIKey("AIzaSyCCF_TMcTsGRp15gGCIOwANG1nYpQpMYAs")
      //  AIzaSyB5xfHcGWzuPesz-MegU46fAdY6ZyfCfMo
        
       // Fabric.with([Digits.self])
        
        GlobalVarible.pemfilevaule = "1"
        
        
        Where = ""
        
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "AbRpAa0ZOX95Zczg8FTE9zUfH63kZ8mRwljpwikUMZcTZUMYksdNph8f0vIHia3jGZByTQGZw3xA0Tqh"])
        

        Stripe.setDefaultPublishableKey("pk_test_529XQobaN0Aa8VMJpqYFdT2n")
        
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 8 support
        else if #available(iOS 8, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
            
        }
            // iOS 7 support
        else {
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }


        let langId = NSLocale.current.languageCode
        
        
        
        if ((UserDefaults.standard.string(forKey: "PreferredLanguage")) != nil){
            GlobalVarible.languagecodeselectinmenu = 1
            GlobalVarible.languagecode = UserDefaults.standard.string(forKey: "PreferredLanguage")!
            // Language.language = Language(rawValue: langId!)!
            
        } else{
            
            GlobalVarible.languagecode = langId!
            print (langId!)
            UserDefaults.standard.set(langId, forKey: "PreferredLanguage")
            // langId = NSLocale.current.languageCode
            // Language.language = Language(rawValue: langId!)!
            
        }
        

        
         return  FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions) || true

       // return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
        
        if(GlobalVarible.updatechecklater == 1){
            
            
            
            // debugPrint(appVersion)
            let message: String = "New Version Available. Please update the app first.".localized
            let alertController = UIAlertController(
                title: "UPDATE AVAILABLE ".localized, // This gets overridden below.
                message: message,
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "Update App".localized, style: .cancel) { _ -> Void in
                
                GlobalVarible.rateApp(appId: "id1361918088") { success in
                    
                }
                
                
                
            }
            alertController.addAction(okAction)
            
            
            
            var presentedVC = self.window?.rootViewController
            
            while (presentedVC!.presentedViewController != nil)  {
                presentedVC = presentedVC!.presentedViewController
            }
            
            presentedVC!.present(alertController, animated: true) {
                
            }
                       
        }
            
        else if(GlobalVarible.updatechecklater == 2){
            
            
            
          
            
            let message: String = "New Version Available. Please update the app.".localized
            let alertController = UIAlertController(
                title: "UPDATE AVAILABLE ".localized, // This gets overridden below.
                message: message,
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "Update App".localized, style: .cancel) { _ -> Void in
                
                GlobalVarible.rateApp(appId: "id1361918088") { success in
                    
                }
                
            }
            alertController.addAction(okAction)
            
            let cancelAction = UIAlertAction(title: "Later".localized, style: .default) { _ -> Void in
                
                //self.dismissViewControllerAnimated(true, completion: nil)
                
                
                
            }
            alertController.addAction(cancelAction)
            
            var presentedVC = self.window?.rootViewController
            
            while (presentedVC!.presentedViewController != nil)  {
                presentedVC = presentedVC!.presentedViewController
            }
            
            presentedVC!.present(alertController, animated: true) {
                
            }
                
           
            
        }
            
        else{
            
            
            
        }
        

        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        
        if  GlobalVarible.locationdidactive == 0{
        
        
        }else{
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                debugPrint("No access")
                
                self.showalert5(message: "To continue, let your device turn on location, which uses Google's location services.Please turn on your location from settings.".localized)
                
            case .authorizedAlways, .authorizedWhenInUse:
                debugPrint("Access")
            }
        } else {
            debugPrint("Location services are not enabled")
        }
            
        }
        
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
      
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "location"), object: nil)
       
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        
        
        let googlesigin = GIDSignIn.sharedInstance().handle(url as URL!,
                                                            sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!,
                                                            annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        let facebookurl = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[.sourceApplication] as! String!, annotation: options[.annotation])
        
        //       let facebookurl = SDKApplicationDelegate.shared.application(app,open: url as URL!,sourceApplication: (options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!),
        //            annotation: options[UIApplicationOpenURLOptionsKey.annotation] as Any)
        
        return googlesigin || facebookurl
        
    }
    
    
    
    
    
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        debugPrint("Notifications status: \(notificationSettings)")
        
        if notificationSettings.types == UIUserNotificationType(rawValue: 0){
            debugPrint(notificationSettings.types)
            
            GlobalVarible.notificationvalue = 1
            
            let deviceTokenValue = "7eba6f12589ea1d618359dc10d5633e031aae26a50023e531f712659975a7013"
            
            UserDefaults.standard.setValue(deviceTokenValue, forKey:"device_key")
            //  self.showalert2("Please first turn on Notification from Settings.")
            
            
        }else{
            debugPrint(notificationSettings.types)
            
            GlobalVarible.notificationvalue = 0
        }
        
        
    }
    
    

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        GlobalVarible.notificationvalue = 0
        debugPrint(deviceTokenString
        )
        // let device_id = UIDevice.currentDevice().identifierForVendor?.UUIDString
        
        //  NSUserDefaults.standardUserDefaults().setObject(device_id, forKey: "DeviceId")
        
        UserDefaults.standard.setValue(deviceTokenString, forKey:"device_key")
        UserDefaults.standard.synchronize()
        
        if  GlobalVarible.afterallownotificationsetting == 1{
            
            GlobalVarible.afterallownotificationsetting = 0
            
            let userid = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyuserid)
            
            let UserDeviceKey = UserDefaults.standard.string(forKey: "device_key")
            
            let uniqueid =  UserDefaults.standard.string(forKey: "unique_number")
            
            ApiManager.sharedInstance.protocolmain_Catagory = self
            ApiManager.sharedInstance.UserDeviceId(USERID: userid!, USERDEVICEID: UserDeviceKey! , FLAG: "1",UNIQUEID: uniqueid!)
            

            
            
        }else{
            
        }
        
    }
    
    
    
       
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
      
        debugPrint("APNs registration failed: \(error)")
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        
        debugPrint("Push notification received: \(data)")
        
        
            
        if let aps = data["aps"] as? NSDictionary {
          
            if let alert = aps["alert"] as? NSString {
                //Do stuff
                part1 = alert as String
                  debugPrint("Part 1: \(part1)")
                
                
                part2 = aps["ride_id"] as! String
                debugPrint("Part 2: \(part2)")
                
                part3 = aps["ride_status"] as! String
                debugPrint("Part 3: \(part3)")
                
            }
        }

        
        
        
       if ( application.applicationState == UIApplicationState.inactive || application.applicationState == UIApplicationState.background  || application.applicationState == UIApplicationState.active )
        
       // if (application.applicationState == UIApplicationState.inactive || application.applicationState == UIApplicationState.background)
        {
            
            Where = "notification"
            
            
            if(part3 == "3"){
                
                let Userid = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyuserid)
               GlobalVarible.checkRideId = part2
                UserDefaults.standard.setValue("3", forKey:"firebaseride_status")

            //    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hide"), object: nil, userInfo: data)
                
                ApiManager.sharedInstance.protocolmain_Catagory = self
                ApiManager.sharedInstance.customerSync1(RideId: part2, UserId: Userid!)
            
                
                
            }
            
            if(part3 == "4"){
                
                let Userid = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyuserid)

                
              //  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hide"), object: nil, userInfo: data)
                
                ApiManager.sharedInstance.protocolmain_Catagory = self
                ApiManager.sharedInstance.customerSync1(RideId: part2, UserId: Userid!)
                
            }
            
            if(part3 == "20"){
                
                 GlobalVarible.changeddestination = 1
                
                 let Userid = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyuserid)
               
                // GlobalVarible.changeddestination = 0
                ApiManager.sharedInstance.protocolmain_Catagory = self
                ApiManager.sharedInstance.customerSync1(RideId: part2, UserId: Userid!)
                
               // self.shownewalert1(message: NSLocalizedString("Your Drop location has been changed by driver", comment: ""))
                
                
                
            }
            
            if(part3 == "22"){
                
                
                self.showalert10(message: part1)
            }

            
            if(part3 == "5"){
                 GlobalVarible.checkRideId = part2
                let Userid = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyuserid)
                UserDefaults.standard.setValue("5", forKey:"firebaseride_status")

                ApiManager.sharedInstance.protocolmain_Catagory = self
                ApiManager.sharedInstance.customerSync1(RideId: part2, UserId: Userid!)
                
                
                
                
                
            }
            
            if(part3 == "6"){
                
                
                 GlobalVarible.checkRideId = part2
                UserDefaults.standard.setValue("6", forKey:"firebaseride_status")

                let Userid = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyuserid)
                
                ApiManager.sharedInstance.protocolmain_Catagory = self
                ApiManager.sharedInstance.customerSync1(RideId: part2, UserId: Userid!)
                
                
                
            }
            if(part3 == "51"){
                
                
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let nextController: NotificationViewController = storyboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
                
                
                var presentedVC = self.window?.rootViewController
                
                while (presentedVC!.presentedViewController != nil)  {
                    presentedVC = presentedVC!.presentedViewController
                }
                presentedVC!.present(nextController, animated: true, completion: nil)

            
                
                
            }
            

            
            
            
            
            if(part3 == "7"){
                
                 // GlobalVarible.checkRideId = part2
                
                UserDefaults.standard.setValue("7", forKey:"firebaseride_status")

                let Userid = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyuserid)
                
                ApiManager.sharedInstance.protocolmain_Catagory = self
                ApiManager.sharedInstance.customerSyncEnd(RideId: part2, UserId: Userid!)
                
                
                
                
                
            }
            
            
            
            
            if(part3 == "9"){
                
                 GlobalVarible.checkRideId = "0"
                UserDefaults.standard.setValue("0", forKey:"firebaseride_status")
                
                let Userid = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyuserid)
                
                ApiManager.sharedInstance.protocolmain_Catagory = self
                ApiManager.sharedInstance.customerSync1(RideId: part2, UserId: Userid!)
                
                
                
                //  self.showalert1("Your Ride Cancel by Driver!!")
                
            }
            
            if(part3 == "11"){
                
                
                GlobalVarible.checkRideId = part2
                UserDefaults.standard.setValue("11", forKey:"firebaseride_status")
                

                
                ApiManager.sharedInstance.protocolmain_Catagory = self
                ApiManager.sharedInstance.RentalUserSync(BookindId: part2)

                
               // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hide1"), object: nil, userInfo: data)
                
                
            }
            
            if(part3 == "12"){
                
                GlobalVarible.checkRideId = part2
                UserDefaults.standard.setValue("12", forKey:"firebaseride_status")
                

                
                ApiManager.sharedInstance.protocolmain_Catagory = self
                ApiManager.sharedInstance.RentalUserSync(BookindId: part2)
                
            }
            
            if(part3 == "13"){
                
                GlobalVarible.checkRideId = part2
                UserDefaults.standard.setValue("13", forKey:"firebaseride_status")
                

                
                ApiManager.sharedInstance.protocolmain_Catagory = self
                ApiManager.sharedInstance.RentalUserSync(BookindId: part2)
                
                
                
            }
            
            if(part3 == "14"){
                
                
                ApiManager.sharedInstance.protocolmain_Catagory = self
                ApiManager.sharedInstance.RentalUserSync(BookindId: part2)

               // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hide1"), object: nil, userInfo: data)
                
                
            }
            
            
            
            
            if(part3 == "16"){
                
                GlobalVarible.checkRideId = part2
                UserDefaults.standard.setValue("16", forKey:"firebaseride_status")
                

                
                ApiManager.sharedInstance.protocolmain_Catagory = self
                ApiManager.sharedInstance.RentalUserSync(BookindId: part2)
                
            }
            
            if(part3 == "17"){
                
                GlobalVarible.checkRideId = "0"
                UserDefaults.standard.setValue("0", forKey:"firebaseride_status")
                
                let Userid = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyuserid)
                
                ApiManager.sharedInstance.protocolmain_Catagory = self
                ApiManager.sharedInstance.customerSync1(RideId: part2, UserId: Userid!)
            
            }
            
            if(part3 == "18"){
                
                GlobalVarible.checkRideId = "0"
                UserDefaults.standard.setValue("0", forKey:"firebaseride_status")
                
                ApiManager.sharedInstance.protocolmain_Catagory = self
                ApiManager.sharedInstance.RentalUserSync(BookindId: part2)

                
            }
            
            if(part3 == "19"){
                
                GlobalVarible.checkRideId = "0"
                UserDefaults.standard.setValue("0", forKey:"firebaseride_status")
                
                 self.showalert1(message: "Your Ride Cancel by Admin!!".localized)
                
             /*   ApiManager.sharedInstance.protocolmain_Catagory = self
                ApiManager.sharedInstance.RentalUserSync(BookindId: part2)*/

                
            }
            
            

            
            
        }
        
        
        
    }
    
    
    func showalert10(message:String)  {
        
        DispatchQueue.main.async(execute: {
            
            let alertController = UIAlertController(title: "Alert".localized, message:message, preferredStyle: .alert)
            
            
            let OKAction = UIAlertAction(title: "ok".localized, style: .default) { (action) in
                
            }
            alertController.addAction(OKAction)
            
            var presentedVC = self.window?.rootViewController
            
            while (presentedVC!.presentedViewController != nil)  {
                presentedVC = presentedVC!.presentedViewController
            }
            
            presentedVC!.present(alertController, animated: true) {
                
            }
            

          
            
        })
        
    }

    
    
    func showalert5(message:String)  {
        
        DispatchQueue.main.async(execute: {
            
            let alertController = UIAlertController(title:   "Alert".localized, message:message, preferredStyle: .alert)
            
            
            let OKAction = UIAlertAction(title: "ok".localized, style: .default) { (action) in
                
                
                UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
                
            }
            alertController.addAction(OKAction)
            
            var presentedVC = self.window?.rootViewController
            
            while (presentedVC!.presentedViewController != nil)  {
                presentedVC = presentedVC!.presentedViewController
            }
            
            presentedVC!.present(alertController, animated: true) {
                
            }
            
            
            
            
        })
        
    }

    
    
    
    
    func showalert4(message:String)  {
        
        DispatchQueue.main.async(execute: {
            
            let alertController = UIAlertController(title:  "Alert".localized, message:message, preferredStyle: .alert)
            
            
            let OKAction = UIAlertAction(title: "ok".localized, style: .default) { (action) in
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let TrackViewController = storyBoard.instantiateViewController(withIdentifier: "RentalTrackRideViewController") as! RentalTrackRideViewController
                // TrackViewController.mydatapage = self.driverdata
                TrackViewController.Currentrideid = self.part2
                TrackViewController.currentStatus = self.part3
                TrackViewController.currentmessage = self.part1
                var presentedVC = self.window?.rootViewController
                while (presentedVC!.presentedViewController != nil)  {
                    presentedVC = presentedVC!.presentedViewController
                }
                presentedVC!.present(TrackViewController, animated: true, completion: nil)
                //  self.present(TrackViewController, animated:true, completion:nil)
                
            }
            alertController.addAction(OKAction)
            
            var presentedVC = self.window?.rootViewController
            
            while (presentedVC!.presentedViewController != nil)  {
                presentedVC = presentedVC!.presentedViewController
            }
            
            presentedVC!.present(alertController, animated: true) {
                
            }
            

                
                       
            
        })
        
    }

    
    
    func showalert3(message:String)  {
        
        DispatchQueue.main.async(execute: {
            
            let alertController = UIAlertController(title:   "Alert".localized, message:message, preferredStyle: .alert)
            
            
            let OKAction = UIAlertAction(title: "ok".localized, style: .default) { (action) in
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let TrackViewController = storyBoard.instantiateViewController(withIdentifier: "TrackRideViewController") as! TrackRideViewController
                // TrackViewController.mydatapage = self.driverdata
                TrackViewController.Currentrideid = self.part2
                TrackViewController.currentStatus = self.part3
                TrackViewController.currentmessage = self.part1
                
                var presentedVC = self.window?.rootViewController
                while (presentedVC!.presentedViewController != nil)  {
                    presentedVC = presentedVC!.presentedViewController
                }
                presentedVC!.present(TrackViewController, animated: true, completion: nil)
              //  self.present(TrackViewController, animated:true, completion:nil)
                
            }
            alertController.addAction(OKAction)
            
            var presentedVC = self.window?.rootViewController
            
            while (presentedVC!.presentedViewController != nil)  {
                presentedVC = presentedVC!.presentedViewController
            }
            
            presentedVC!.present(alertController, animated: true) {
                
            }

            
            
        })
        
    }
    
    func showalert2(message:String)  {
        
        DispatchQueue.main.async(execute: {
            
            let alertController = UIAlertController(title:  "Alert".localized, message:message, preferredStyle: .alert)
            
            
            let OKAction = UIAlertAction(title: "ok".localized, style: .default) { (action) in
                
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let nextController: MapViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                var presentedVC = self.window?.rootViewController
                while (presentedVC!.presentedViewController != nil)  {
                    presentedVC = presentedVC!.presentedViewController
                }
                presentedVC!.present(nextController, animated: true, completion: nil)
                
                
            }
            alertController.addAction(OKAction)
            
            var presentedVC = self.window?.rootViewController
            
            while (presentedVC!.presentedViewController != nil)  {
                presentedVC = presentedVC!.presentedViewController
            }
            
            presentedVC!.present(alertController, animated: true) {
                
            }

            
            
        })
        
    }
    
    
    

    
    
    
    
    func showalert1(message:String)  {
        
        DispatchQueue.main.async(execute: {
            
            let alertController = UIAlertController(title: "Alert".localized, message:message, preferredStyle: .alert)
            
            
            let OKAction = UIAlertAction(title: "ok".localized, style: .default) { (action) in
                
               /* let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let nextController: MapViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                var presentedVC = self.window?.rootViewController
                while (presentedVC!.presentedViewController != nil)  {
                    presentedVC = presentedVC!.presentedViewController
                }
                presentedVC!.present(nextController, animated: true, completion: nil)*/
                
                self.window?.rootViewController?.dismiss(animated: true, completion: nil)
                
            }
            alertController.addAction(OKAction)
            
            var presentedVC = self.window?.rootViewController
            
            while (presentedVC!.presentedViewController != nil)  {
                presentedVC = presentedVC!.presentedViewController
            }
            
            presentedVC!.present(alertController, animated: true) {
                
            }
            
            
        })
        
    }
    
    
    func shownewalert1(message:String)  {
        
        DispatchQueue.main.async(execute: {
            
            let alertController = UIAlertController(title: "Alert".localized, message:message, preferredStyle: .alert)
            
            
            let OKAction = UIAlertAction(title: "ok".localized, style: .default) { (action) in
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let TrackViewController = storyBoard.instantiateViewController(withIdentifier: "TrackRideViewController") as! TrackRideViewController
                TrackViewController.Currentrideid = self.part2
                               
                var presentedVC = self.window?.rootViewController
                while (presentedVC!.presentedViewController != nil)  {
                    presentedVC = presentedVC!.presentedViewController
                }
                presentedVC!.present(TrackViewController, animated: true, completion: nil)
                
                
 
                
            }
                
              //  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "trackride"), object: nil, userInfo: nil)
            alertController.addAction(OKAction)
            
            var presentedVC = self.window?.rootViewController
            
            while (presentedVC!.presentedViewController != nil)  {
                presentedVC = presentedVC!.presentedViewController
            }
            
            presentedVC!.present(alertController, animated: true) {
                
            }
            
            
        })
        
    }



    
    func onProgressStatus(value: Int) {
        if(value == 0 ){
            
        }else if (value == 1){
            
        }
    }
    
    func onSuccessExecution(msg: String) {
        debugPrint("msg")
        
    }
    
    
    func onerror(msg : String) {
        
        
    }
    
    func onSuccessParse(data: AnyObject) {
        
        
       

        if(GlobalVarible.Api == "customersync"){
            
            customersyncdata = data as! CustomerSyncModel
            
            if(customersyncdata.result == 0){
                
                self.showalert1(message: "Your Notification has been expired!!".localized)
                
                
            }else
            {
                
                  if(customersyncdata.details?.rideStatus == "3"){
                    
                     UserDefaults.standard.setValue("3", forKey:"firebaseride_status")
                    
                    GlobalVarible.timerForGetDriverLocation1.invalidate()
                    self.showalert3( message: NSLocalizedString("Your Ride is Successfully Booked!!".localized, comment: ""))
                    
                    
                }
                if(customersyncdata.details?.rideStatus == "4"){
                    
                    GlobalVarible.timerForGetDriverLocation1.invalidate()
                      self.showalert2(message: NSLocalizedString("Your Ride has been Rejected!!".localized, comment: ""))
                    
                    
                }
                
                
                if(customersyncdata.details?.rideStatus == "5"){
                    
                    UserDefaults.standard.setValue("5", forKey:"firebaseride_status")
                    
                    
                    GlobalVarible.checkridestatus = self.part3
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "trackride"), object: nil, userInfo: nil)
                    
                  /*  let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextController: TrackRideViewController = storyboard.instantiateViewController(withIdentifier: "TrackRideViewController") as! TrackRideViewController
                    
                    nextController.Currentrideid = self.part2
                    nextController.currentStatus = self.part3
                    nextController.currentmessage = self.part1
                    
                    
                    var presentedVC = self.window?.rootViewController
                    
                    while (presentedVC!.presentedViewController != nil)  {
                        presentedVC = presentedVC!.presentedViewController
                    }
                    presentedVC!.present(nextController, animated: true, completion: nil)*/
                    
                    
                    
                }
                
                if(customersyncdata.details?.rideStatus == "6"){
                    
                    UserDefaults.standard.setValue("6", forKey:"firebaseride_status")
                    
                    GlobalVarible.checkridestatus = self.part3
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "trackride"), object: nil, userInfo: nil)
                  /*  let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextController: TrackRideViewController = storyboard.instantiateViewController(withIdentifier: "TrackRideViewController") as! TrackRideViewController
                
                    nextController.Currentrideid = self.part2
                    nextController.currentStatus = self.part3
                    nextController.currentmessage = self.part1
                    
                    
                    var presentedVC = self.window?.rootViewController
                    
                    while (presentedVC!.presentedViewController != nil)  {
                        presentedVC = presentedVC!.presentedViewController
                    }
                    presentedVC!.present(nextController, animated: true, completion: nil)*/
                    
                    
                    
                }
                
                if(customersyncdata.details?.rideStatus == "9"){
                    
                    
                    self.showalert1(message: "Your Ride Cancel by Driver!!".localized)
                }
                
                 if(customersyncdata.details?.rideStatus == "17"){
                    
                    self.showalert1(message: "Your Ride Cancel by Admin!!".localized)
                    
                }
                
                
                
            }
            
        }
        
        if(GlobalVarible.Api == "customersyncend"){
            
            customersyncdata = data as! CustomerSyncModel
            
            if(customersyncdata.result == 0){
                
                self.showalert1(message: "Your Notification has been expired!!".localized)
                
                
            }else
            {
                UserDefaults.standard.setValue("7", forKey:"firebaseride_status")
                
                if(customersyncdata.details?.rideStatus == "7"){
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextController: PaymentWebViewController = storyboard.instantiateViewController(withIdentifier: "PaymentWebViewController") as! PaymentWebViewController
                    
                    nextController.currentrideid = self.part2
                    
                    
                    var presentedVC = self.window?.rootViewController
                    
                    while (presentedVC!.presentedViewController != nil)  {
                        presentedVC = presentedVC!.presentedViewController
                    }
                    presentedVC!.present(nextController, animated: true, completion: nil)
                    
                }
            }
        }
        
        
        if(GlobalVarible.Api == "rentalridesync"){
            
           rentalridesyncdata = data as! RentalRideSyncModel
            
            if(rentalridesyncdata.status == 0){
                
                self.showalert1(message: "Your Notification has been expired!!".localized)
                
                
            }else
            {
                
                if(rentalridesyncdata.details?.bookingStatus == "11"){
                    GlobalVarible.timerForGetDriverLocation1.invalidate()
                  self.showalert4( message: "Your Ride is Successfully Booked!!".localized)
                    
                    
                }
                
                
                if(rentalridesyncdata.details?.bookingStatus == "14"){
                        GlobalVarible.timerForGetDriverLocation1.invalidate()
                     self.showalert2(message: "Your Ride has been Rejected!!".localized)
                    
                    
                }
                
                if(rentalridesyncdata.details?.bookingStatus == "12"){
                    
                    
                    GlobalVarible.checkridestatus = self.part3
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "rentaltrackride"), object: nil, userInfo: nil)
                    
                  /* let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextController: RentalTrackRideViewController = storyboard.instantiateViewController(withIdentifier: "RentalTrackRideViewController") as! RentalTrackRideViewController
                    
                    nextController.Currentrideid = self.part2
                    nextController.currentStatus = self.part3
                    nextController.currentmessage = self.part1
                    
                    
                    var presentedVC = self.window?.rootViewController
                    
                    while (presentedVC!.presentedViewController != nil)  {
                        presentedVC = presentedVC!.presentedViewController
                    }
                    presentedVC!.present(nextController, animated: true, completion: nil)*/
                    
                    
                    
                    
                }
                
                if(rentalridesyncdata.details?.bookingStatus == "13"){
                    
                    
                    GlobalVarible.checkridestatus = self.part3
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "rentaltrackride"), object: nil, userInfo: nil)
                    
                   /* let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextController: RentalTrackRideViewController = storyboard.instantiateViewController(withIdentifier: "RentalTrackRideViewController") as! RentalTrackRideViewController
                    
                    nextController.Currentrideid = self.part2
                    nextController.currentStatus = self.part3
                    nextController.currentmessage = self.part1
                    
                    
                    var presentedVC = self.window?.rootViewController
                    
                    while (presentedVC!.presentedViewController != nil)  {
                        presentedVC = presentedVC!.presentedViewController
                    }
                    presentedVC!.present(nextController, animated: true, completion: nil)*/
                    
                    
                    
                    
                }
                
                if(rentalridesyncdata.details?.bookingStatus == "16"){
                    
                    
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextController: RentalRecieptViewController = storyboard.instantiateViewController(withIdentifier: "RentalRecieptViewController") as! RentalRecieptViewController
                    
                    nextController.currentrideid = self.part2
                    
                    
                    var presentedVC = self.window?.rootViewController
                    
                    while (presentedVC!.presentedViewController != nil)  {
                        presentedVC = presentedVC!.presentedViewController
                    }
                    presentedVC!.present(nextController, animated: true, completion: nil)
                    
                    
                    
                    
                }
                
                               
                if(rentalridesyncdata.details?.bookingStatus == "18"){
                    self.showalert1(message: "Your Ride Cancel by Driver!!".localized)
                }
                
                if(rentalridesyncdata.details?.bookingStatus == "19"){
                    
                    self.showalert1(message: "Your Ride Cancel by Admin!!".localized)
                }

            }
            
        }

        
    }
}

