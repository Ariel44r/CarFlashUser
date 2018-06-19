//
//  RideNowViewController.swift
//  TaxiUser
//
//  Created by AppOrio on 23/05/17.
//  Copyright © 2017 apporio. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON
import MapKit
import Firebase

class RideNowViewController: UIViewController,MainCategoryProtocol {
    
    var customersyncdata: CustomerSyncModel!
    
    var distancedata : DistanceModel!
    
    var ridedata: RideEstimate!
    
    var confirmridedata: ConfirmRideModel!
    
    
    
     var usersyncdata: CustomerSyncModel!
    
     var checkdroppointyesno: Int?
    
    var ref = FIRDatabase.database().reference()
    
    @IBOutlet var lblCancel: UILabel!
    @IBOutlet var lblConfirm: UILabel!
    @IBOutlet var lblApplyCoupon: UILabel!
    @IBOutlet var lblETA: UILabel!
    @IBOutlet var lblEstFare: UILabel!


    
    @IBOutlet weak var hiddenview: UIView!
    
    var cancel60secrideid = ""
    
    var timerForGetDriverLocation = Timer()
    
    
    var part1: String = ""
    var part2: String = ""
    var part3: String = ""
    
    var droploclabel1: UILabel!
    
    var driverView: UIView!
    
    var pickloclabel: UILabel!
    
    
    
    var originCoordinate: CLLocationCoordinate2D!
    
    var destinationCoordinate: CLLocationCoordinate2D!

    
    var totaltime = ""
    
    var markerList = [GMSMarker]()
    
  //  let tasks = DirectionButton()
    var originMarker: GMSMarker!
    var destinationMarker: GMSMarker!
  //  var routePolyline: GMSPolyline!
  //  var timer =  Timer()
    ////  var animationPolyline : GMSPolyline!
    ///  var path : GMSPath!
    
   
    var polyline = GMSPolyline()
    var animationPolyline = GMSPolyline()
    var path = GMSPath()
    var animationPath = GMSMutablePath()
    var i: UInt = 0
    var timer: Timer!
    
    ///  var i: UInt = 0
    
    
   // var timerForGetDriverLocation1 = Timer()
    
    
    var viewcontrollerself : UIViewController!
    
    @IBOutlet weak var Mainview: UIView!
    
    let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    
    
    

    
    @IBOutlet weak var locationview: UIView!
    
    @IBOutlet weak var selectpaymentmethodtext: UILabel!
    
    
    @IBOutlet weak var applycoupontext: UILabel!
    
    @IBOutlet weak var mapview: GMSMapView!
    
    @IBOutlet weak var bottomview: UIView!
    
    let imageUrl = API_URL.imagedomain
    
    @IBOutlet weak var pickuplocationtext: UILabel!
    
    @IBOutlet weak var droplocationtext: UILabel!
    
    @IBOutlet weak var droplocationview: UIView!
    
    @IBOutlet weak var imagecircleview: UIView!
    
    @IBOutlet weak var selectimage: UIImageView!
    
    
   let customInfoWindow1 = Bundle.main.loadNibNamed("DriverView", owner: nil, options: nil)?[0] as! DriverView
    
    
    let Userid = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyuserid)
    
    
    @IBOutlet weak var etatimetext: UILabel!
    
    @IBOutlet weak var etaamounttext: UILabel!

    func viewSetup(){
        
        lblCancel.text = "Cancel".localized
        lblConfirm.text = "Confirm".localized
        lblApplyCoupon.text = "Apply Coupon".localized
        lblETA.text = "ETA".localized
        lblEstFare.text = "Est. Fare".localized
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
       // pickuplocationtext.text = GlobalVarible.Pickuptext
       // droplocationtext.text = GlobalVarible.UserDropLocationText
        
        
        self.viewSetup()
              
        droplocationview.layer.borderWidth = 1
        droplocationview.layer.cornerRadius = 3
        droplocationview.layer.borderColor = UIColor.lightGray.cgColor
        
        mapview.layer.borderWidth = 1
        mapview.layer.cornerRadius = 3
        mapview.layer.borderColor = UIColor.lightGray.cgColor
        
        imagecircleview.layer.borderWidth = 1
        imagecircleview.layer.masksToBounds = false
        imagecircleview.layer.borderColor = UIColor.black.cgColor
        imagecircleview.layer.cornerRadius = imagecircleview.frame.height/2
        imagecircleview.clipsToBounds = true
        
        GlobalVarible.couponcodevalue = 0
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showDialog),
            name: NSNotification.Name(rawValue: "show"),
            object: nil)
        
        
        
       NotificationCenter.default.addObserver(
            self,
            selector: #selector(hideDialog),
            name: NSNotification.Name(rawValue: "hide"),
            object: nil)


        
       // GlobalVarible.PaymentOptionId = ""
        GlobalVarible.MatchCardSelect = 0
        
       
        GlobalVarible.checkdialogcancelbtn = 0
        
        let position = CLLocationCoordinate2DMake(Double(GlobalVarible.PickUpLat)!, Double(GlobalVarible.PickUpLng)!)
        // self.setuplocationMarker(position)
        mapview.animate(toLocation: position)
       mapview.animate(toZoom: 14)
        
        if checkdroppointyesno == 1 {
            
            pickuplocationtext.text = GlobalVarible.Pickuptext
            
            droplocationtext.text = "No drop off point".localized
            
            
            etaamounttext.text =  "-----"
            
            etatimetext.text = "-----"
            
        }else if checkdroppointyesno == 2{
            
            let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
            spinnerActivity.label.text = "Loading".localized
            spinnerActivity.detailsLabel.text = "Please Wait!!".localized
            spinnerActivity.isUserInteractionEnabled = false
            


            pickuplocationtext.text = GlobalVarible.Pickuptext
            droplocationtext.text = GlobalVarible.UserDropLocationText
        
        ApiManager.sharedInstance.protocolmain_Catagory = self
        ApiManager.sharedInstance.FindDistance()
        
        }
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        
        if(GlobalVarible.cartypeimage == " "){
            
             selectimage.image = UIImage(named: "car@100") as UIImage?
            //carnametext.text = "null"
        }else{
            let newUrl = imageUrl + GlobalVarible.cartypeimage
            //    let url = "http://apporio.co.uk/apporiotaxi/\(GlobalVarible.cartypeimage)"
            
            let url1 = NSURL(string: newUrl)
            selectimage!.af_setImage(withURL:
                url1! as URL,
                                     placeholderImage: UIImage(named: "dress"),
                                     filter: nil,
                                     imageTransition: .crossDissolve(1.0))
            
        }
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "uber_theme", withExtension: "json") {
                mapview.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        

        
        
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        debugPrint(GlobalVarible.paymentmethod)
        selectpaymentmethodtext.text = GlobalVarible.paymentmethod
        
        
        if(GlobalVarible.checkdialogcancelbtn == 1){
            
            
            
            ApiManager.sharedInstance.protocolmain_Catagory = self
            ApiManager.sharedInstance.CancelRide60Sec(RideID: cancel60secrideid,Auto: "0",RideMode: "1")

        
         
        }
        
        if(GlobalVarible.couponcodevalue == 1){
            applycoupontext.text = "Coupon Applied  ".localized +   GlobalVarible.CouponCode
            GlobalVarible.couponcodevalue = 0
        
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
       /* if checkdroppointyesno == 1 {
            
        }else  if checkdroppointyesno == 2 {
            
            self.timer.invalidate()
            
        }*/
    }

    
   // func getDirections(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: @escaping ((_ status: String, _ success: Bool) -> Void)) {
    func getDirections(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!){
        if let originLocation = origin {
            if let destinationLocation = destination {
                let directionsURLString = baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation + "&key=" + GlobalVarible.googlemapkeys
                
                //  directionsURLString = directionsURLString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                
                debugPrint(directionsURLString)
                
                let directionsURL = NSURL(string: directionsURLString)
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    let directionsData = NSData(contentsOf: directionsURL! as URL)
                    
               
                    
                    do {
      
                    let dictonary:Dictionary<String, Any> = try JSONSerialization.jsonObject(with: directionsData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                        
                        self.drawRoute(routeDict: dictonary)
                        
                    } catch {
                        NSLog("One or more of the map styles failed to load. \(error)")
                    }
                    
                    
              })
            }
            else {
              //  completionHandler("Destination is nil.", false)
            }
        }
        else {
           // completionHandler("Origin is nil", false)
        }

            
        }
    
    
    func drawRoute(routeDict: Dictionary<String, Any>) {
        
        let routesArray = routeDict["routes"] as! NSArray
        
       // let distance = routeDict["routes"][0]["legs"][0]["distance"]["value"].string
        
       
        
         var bounds = GMSCoordinateBounds()
        if (routesArray.count > 0)
        {
            let routeDict = routesArray[0] as! Dictionary<String, Any>
            let routeOverviewPolyline = routeDict["overview_polyline"] as! Dictionary<String, Any>
            let points = routeOverviewPolyline["points"]
            
            self.originCoordinate = CLLocationCoordinate2DMake(Double(GlobalVarible.PickUpLat)!, Double(GlobalVarible.PickUpLng)!)
            
            originMarker = GMSMarker(position: self.originCoordinate)
            
            
          /*  let Fram1 = CGRect(x: 0, y: 0 , width: 150 , height: 70)
            customInfoWindow1.frame = Fram1
            pickloclabel = customInfoWindow1.viewWithTag(1) as! UILabel
            
            driverView = customInfoWindow1.viewWithTag(3)! as UIView
            pickloclabel.text = GlobalVarible.Pickuptext*/
            
            
            
            self.markerList.append(originMarker)
            
            
            originMarker.icon = GMSMarker.markerImage(with: UIColor.green)
         //   originMarker.iconView = driverView
            
            
            originMarker.map = self.mapview

            
            self.destinationCoordinate = CLLocationCoordinate2DMake(GlobalVarible.UserDropLat , GlobalVarible.UserDropLng)
            
            destinationMarker = GMSMarker(position: self.destinationCoordinate)
            
            self.markerList.append(destinationMarker)
            
            
            destinationMarker.icon = GMSMarker.markerImage(with: UIColor.red)
            
      
            destinationMarker.map = self.mapview
            
            
            for marker in markerList {
                bounds = bounds.includingCoordinate(marker.position)
            }
            
            self.path = GMSPath.init(fromEncodedPath: points as! String)!
            
            self.polyline.path = path
          //  self.polyline.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            self.polyline.strokeColor = UIColor.black
            self.polyline.strokeWidth = 3.0
            self.polyline.map = self.mapview
            let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsetsMake(50, 60, 50, 60))
            mapview.animate(with: update)
            
          //  self.timer = Timer.scheduledTimer(timeInterval: 0.020, target: self, selector: #selector(animatePolylinePath), userInfo: nil, repeats: true)
           MBProgressHUD.hide(for: self.view, animated: true)

            
        }
    }
    
    func animatePolylinePath() {
        if (self.i < self.path.count()) {
            self.animationPath.add(self.path.coordinate(at: self.i))
            self.animationPolyline.path = self.animationPath
            self.animationPolyline.strokeColor = UIColor.black
            self.animationPolyline.strokeWidth = 3
            self.animationPolyline.map = self.mapview
            self.i += 1
            
        }
        else {
            self.i = 0
            self.animationPath = GMSMutablePath()
            self.animationPolyline.map = nil
            
        }
    }
    
    @IBAction func cancelbtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func confirmbtn(_ sender: Any) {
        
        
        if  GlobalVarible.notificationvalue == 1
            
        {
            // self.showalert2("Please first turn on Notification from Settings.")
            
            self.showalert5(message: "If you want to book ride. Please, go to settings and allow notification permissions.".localized)
            
            
        }else{
            
            
                    hiddenview.isHidden = false
                      
    
                let Droplat = String(GlobalVarible.UserDropLat)
                let DropLng = String(GlobalVarible.UserDropLng)
                
                ApiManager.sharedInstance.protocolmain_Catagory = self
                ApiManager.sharedInstance.ConfirmRide(USERID: self.Userid!,COUPONCODE: GlobalVarible.CouponCode,USERCURRENTLAT: GlobalVarible.PickUpLat,USERCURRENTLONG: GlobalVarible.PickUpLng,CURRENTADDRESS: GlobalVarible.Pickuptext,DROPLAT: Droplat,DROPLNG: DropLng,DropLOCATION: GlobalVarible.UserDropLocationText,RIDETYPE: "1",RIDESTATUS: "1",CARTYPEID: GlobalVarible.cartypeid,PaymentOPtionId: GlobalVarible.PaymentOptionId,CardId: GlobalVarible.CardId)
         //   }
            
            // self.bookRide()
            
            
        }
        

    }

    @IBAction func selectpaymentmethodbtn(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let paymentviewcontroller = storyBoard.instantiateViewController(withIdentifier: "SelectPaymentViewController") as! SelectPaymentViewController
        paymentviewcontroller.viewcontrollerself = self
        paymentviewcontroller.modalPresentationStyle = .overCurrentContext
        //  paymentviewcontroller.modalPresentationStyle = .Popover
        self.present(paymentviewcontroller, animated:true, completion:nil)
    }
    
    
    @IBAction func applycouponbtn(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let couponcodeviewcontroller = storyBoard.instantiateViewController(withIdentifier: "CouponsCodeViewController") as! CouponsCodeViewController
        couponcodeviewcontroller.viewcontrollerself = self
       couponcodeviewcontroller.modalPresentationStyle = .overCurrentContext
        //  paymentviewcontroller.modalPresentationStyle = .Popover
        self.present(couponcodeviewcontroller, animated:true, completion:nil)
        
        
        
    }
    
       

    
  
    
    func showalert5(message:String)  {
        
        DispatchQueue.main.async(execute: {
            
            let alertController = UIAlertController(title:   "Alert".localized, message:message, preferredStyle: .alert)
            
            
            let OKAction = UIAlertAction(title: "ok".localized, style: .default) { (action) in
                
                GlobalVarible.afterallownotificationsetting = 1
                
                UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
                
            }
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true) {
                
            }
            
            
        })
        
    }
    
    func showalert1(message:String)  {
        
        DispatchQueue.main.async(execute: {
            
            let alertController = UIAlertController(title:   "Alert".localized, message:message, preferredStyle: .alert)
            
            
            let OKAction = UIAlertAction(title: "ok".localized, style: .default) { (action) in
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let TrackViewController = storyBoard.instantiateViewController(withIdentifier: "TrackRideViewController") as! TrackRideViewController
                // TrackViewController.mydatapage = self.driverdata
                TrackViewController.Currentrideid = self.part2
                TrackViewController.currentStatus = self.part3
                TrackViewController.currentmessage = self.part1
                self.present(TrackViewController, animated:true, completion:nil)
                
            }
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true) {
                
            }
            
            
        })
        
    }
    
    func showalert2(message:String)  {
        
        DispatchQueue.main.async(execute: {
            
            let alertController = UIAlertController(title:   "Alert".localized, message:message, preferredStyle: .alert)
            
            
            let OKAction = UIAlertAction(title: "ok".localized, style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
                self.hiddenview.isHidden = true

                
            }
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true) {
                
            }
            
            
        })
        
    }
    

    


    
    func showalert(message:String)  {
        
        DispatchQueue.main.async(execute: {
            
            let alertController = UIAlertController(title:   "Alert".localized, message:message, preferredStyle: .alert)
            
            
            let OKAction = UIAlertAction(title: "ok".localized, style: .default) { (action) in
                
            }
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true) {
                
            }
            
            
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
        debugPrint("\(msg)")
    }
    
    
    func onerror(msg : String) {
        MBProgressHUD.hide(for: self.view, animated: true)
        
        self.showalert(message: msg)
        
    }
    
    
    func onSuccessParse(data: AnyObject) {
        
        
        
        if(GlobalVarible.Api == "usersyncwhenappterminate"){
            
            usersyncdata = data as! CustomerSyncModel
            
            
            if(usersyncdata.result == 0){
                
               
                
                //   self.showalert1(message: "Your Notification has been expired!!")
                
                
            }else
            {
                
                 GlobalVarible.timerForGetDriverLocation1.invalidate()
                
                if(usersyncdata.details?.rideStatus == "3"){
                    
                    // self.matchvalue = 0
                    
                    GlobalVarible.timerForGetDriverLocation1.invalidate()
                    
                    GlobalVarible.checkRideId = (usersyncdata.details?.rideId)!
                    
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextController: TrackRideViewController = storyboard.instantiateViewController(withIdentifier: "TrackRideViewController") as! TrackRideViewController
                    nextController.Currentrideid = (usersyncdata.details?.rideId)!
                    nextController.currentStatus = (usersyncdata.details?.rideStatus)!
                    self.present(nextController, animated: true, completion: nil)
                    
                }
                
                if(usersyncdata.details?.rideStatus == "2"){
                    
                    hiddenview.isHidden = true
                    
                    self.dismiss(animated: true, completion: nil)
                                        
                    GlobalVarible.timerForGetDriverLocation1.invalidate()
                    
                    if(GlobalVarible.checkdialogcancelbtn == 1){
                        
                        GlobalVarible.checkdialogcancelbtn = 0
                        
                        
                    }else{
                        
                    self.dismiss(animated: true, completion: nil)
                     self.showalert(message: "Sorry no driver is available!".localized)
                        
                    }
                }
                
                
                if(usersyncdata.details?.rideStatus == "5"){
                    
                    // self.matchvalue = 0
                    
                    GlobalVarible.checkRideId = (usersyncdata.details?.rideId)!
                    
                    
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextController: TrackRideViewController = storyboard.instantiateViewController(withIdentifier: "TrackRideViewController") as! TrackRideViewController
                    nextController.Currentrideid = (usersyncdata.details?.rideId)!
                    nextController.currentStatus = (usersyncdata.details?.rideStatus)!
                    self.present(nextController, animated: true, completion: nil)
                    
                    
                    
                    
                }
                
                if(usersyncdata.details?.rideStatus == "6"){
                    
                    // self.matchvalue = 0
                    
                    GlobalVarible.checkRideId = (usersyncdata.details?.rideId)!
                    
                    
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextController: TrackRideViewController = storyboard.instantiateViewController(withIdentifier: "TrackRideViewController") as! TrackRideViewController
                    nextController.Currentrideid = (usersyncdata.details?.rideId)!
                    nextController.currentStatus = (usersyncdata.details?.rideStatus)!
                    self.present(nextController, animated: true, completion: nil)
                    
                    
                }
                
                if(usersyncdata.details?.rideStatus == "7"){
                    
                    //  GlobalVarible.checkRideId = (usersyncdata.details?.rideId)!
                    
                    
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextController: PaymentWebViewController = storyboard.instantiateViewController(withIdentifier: "PaymentWebViewController") as! PaymentWebViewController
                    
                    nextController.currentrideid = (usersyncdata.details?.rideId)!
                    
                    
                    self.present(nextController, animated: true, completion: nil)
                    
                }
                
                if(usersyncdata.details?.rideStatus == "11"){
                    
                    
                    GlobalVarible.checkRideId = (usersyncdata.details?.rideId)!
                    
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextController: RentalTrackRideViewController = storyboard.instantiateViewController(withIdentifier: "RentalTrackRideViewController") as! RentalTrackRideViewController
                    nextController.Currentrideid = (usersyncdata.details?.rideId)!
                    nextController.currentStatus = (usersyncdata.details?.rideStatus)!
                    self.present(nextController, animated: true, completion: nil)
                    
                }
                
                if(usersyncdata.details?.rideStatus == "12"){
                    
                    GlobalVarible.checkRideId = (usersyncdata.details?.rideId)!
                    
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextController: RentalTrackRideViewController = storyboard.instantiateViewController(withIdentifier: "RentalTrackRideViewController") as! RentalTrackRideViewController
                    nextController.Currentrideid = (usersyncdata.details?.rideId)!
                    nextController.currentStatus = (usersyncdata.details?.rideStatus)!
                    self.present(nextController, animated: true, completion: nil)
                    
                }
                
                if(usersyncdata.details?.rideStatus == "13"){
                    
                    GlobalVarible.checkRideId = (usersyncdata.details?.rideId)!
                    
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextController: RentalTrackRideViewController = storyboard.instantiateViewController(withIdentifier: "RentalTrackRideViewController") as! RentalTrackRideViewController
                    nextController.Currentrideid = (usersyncdata.details?.rideId)!
                    nextController.currentStatus = (usersyncdata.details?.rideStatus)!
                    self.present(nextController, animated: true, completion: nil)
                    
                }
                
                if(usersyncdata.details?.rideStatus == "16"){
                    
                    GlobalVarible.checkRideId = (usersyncdata.details?.rideId)!
                    
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextController: RentalRecieptViewController = storyboard.instantiateViewController(withIdentifier: "RentalRecieptViewController") as! RentalRecieptViewController
                    
                    nextController.currentrideid = (usersyncdata.details?.rideId)!
                    
                    self.present(nextController, animated: true, completion: nil)
                }
                
                
                
                
                
            }
            
        }
        
        
        
        if(GlobalVarible.Api == "confirmridebook"){
            
            confirmridedata = data as! ConfirmRideModel
            
           
            
            if(confirmridedata.result == 1){
                
                cancel60secrideid = (confirmridedata.details?.rideId)!
                
                
                
              
             GlobalVarible.checkRideId = cancel60secrideid
                
               //  MBProgressHUD.hide(for: self.view, animated: true)
                
               let Message: NSDictionary = ["changed_destination": "0","ride_id": cancel60secrideid,"ride_status": "1","done_ride_id": ""]
                
                 self.ref.child("RideTable").child(cancel60secrideid).setValue(Message)
                
                debugPrint(cancel60secrideid)
                
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "show"), object: nil)
                
               GlobalVarible.timerForGetDriverLocation1 = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(RideNowViewController.getDriverLocation), userInfo: nil, repeats: true)
                
             
                
            }else{
                
                hiddenview.isHidden = true
                self.showalert(message: confirmridedata.msg!)
                debugPrint("Ride Book Unsuccessfully")
            }
            
            
        }

        
        if(GlobalVarible.Api == "distancetype"){
            
            distancedata = data as! DistanceModel
            
            if(distancedata.status == "OK"){
                
                if(distancedata.rows![0].elements![0].status! == "ZERO_RESULTS"){
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                }else{

                
                let distance = String(distancedata.rows![0].elements![0].distance!.value!)
                    
                     let ridetime = String(distancedata.rows![0].elements![0].duration!.value!)
                
                totaltime = String(distancedata.rows![0].elements![0].duration!.text!)
                
                
                ApiManager.sharedInstance.protocolmain_Catagory = self
                
                
                ApiManager.sharedInstance.RideEstimatedScreen(Distance: distance, CITYID: GlobalVarible.Cityid, CARTYPEId: GlobalVarible.cartypeid,RideTime: ridetime)
                    
                }
                
            }else{
                
                
            }
        }
        
        
        
        
        
        
        if(GlobalVarible.Api == "rideestimateresponse"){
            
            ridedata = data as! RideEstimate
            
            
            if(ridedata.result == 0){
                
                
                etaamounttext.text = "No Record Found".localized
                
                etatimetext.text = totaltime
            }else{
                
                             
                etaamounttext.text =  GlobalVarible.currencysymbol + " " + ridedata.msg!
                
                etatimetext.text = totaltime
                
              //  self.createRoute()
                let origin = GlobalVarible.PickUpLat + "," + GlobalVarible.PickUpLng
                let destination = String(GlobalVarible.UserDropLat) + "," + String(GlobalVarible.UserDropLng)
                
                self.getDirections(origin: origin, destination: destination, waypoints: nil, travelMode: nil)
                   
            }
        }
        
        if(GlobalVarible.Api == "customersync"){
            
            customersyncdata = data as! CustomerSyncModel
            
            
            if(customersyncdata.result == 0){
                
              //  MBProgressHUD.hide(for: self.view, animated: true)

                  self.dismiss(animated: true, completion: nil)
              /* let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let revealViewController:MapViewController = storyBoard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                
                self.present(revealViewController, animated:true, completion:nil)*/
                
              let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let nextController: MapViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                
                if let window = self.view.window{
                    window.rootViewController = nextController
                }
                
                // self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                
                
                
            }else
            {
                if(customersyncdata.details?.rideStatus == "3"){
                   // MBProgressHUD.hide(for: self.view, animated: true)
                      self.dismiss(animated: true, completion: nil)
                    DispatchQueue.main.async(execute: {
                        
                        self.showalert1( message: "Your Ride is Successfully Booked!!".localized)
                        
                    })
                    
                    GlobalVarible.MatchStringforCancel = "HideCancelButton"
                    
                    
                    
                }
                
                if(customersyncdata.details?.rideStatus == "4"){
                    
                   // MBProgressHUD.hide(for: self.view, animated: true)
                      self.dismiss(animated: true, completion: nil)
                    
                   DispatchQueue.main.async(execute: {
                        
                        self.showalert2(message: "Your Ride has been Rejected!!".localized)
                        
                        
                    })
                    
                    
                }
                
                
                if(customersyncdata.details?.rideStatus == "5"){
                    
                    GlobalVarible.CurrentRideStatus = part3
                    
                }
                


        
                
            }
            
            
            
        }
        

    }
    
    
    func getDriverLocation(timer : Timer){
        
      /*  hiddenview.isHidden = true
        
       // MBProgressHUD.hide(for: self.view, animated: true)
        self.dismiss(animated: true, completion: nil)
        
        GlobalVarible.timerForGetDriverLocation1.invalidate()*/
        
        ApiManager.sharedInstance.protocolmain_Catagory = self
        ApiManager.sharedInstance.CancelRide60Sec(RideID: cancel60secrideid,Auto: "1",RideMode: "1")
        
        
       
    }
    
    
    
    func showDialog(notification: NSNotification){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let dialogviewcontroller = storyBoard.instantiateViewController(withIdentifier: "DialogViewController") as! DialogViewController
         dialogviewcontroller.modalPresentationStyle = .overCurrentContext
         dialogviewcontroller.viewcontrollerself = self
              //  paymentviewcontroller.modalPresentationStyle = .Popover
        self.present(dialogviewcontroller, animated:true, completion:nil)
        
        
      /*  let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinnerActivity.label.text = NSLocalizedString("Loading", comment: "")
        spinnerActivity.detailsLabel.text = NSLocalizedString("Please Wait!!", comment: "")
        spinnerActivity.isUserInteractionEnabled = false*/
        
    }
    
    func hideDialog(notification: NSNotification){
        
        GlobalVarible.timerForGetDriverLocation1.invalidate()
        
        
        debugPrint("Driver Accepted")
        
        
        let totalvalue = notification.userInfo!
        
        debugPrint(totalvalue)
        
        
        
        if let aps = totalvalue["aps"] as? NSDictionary {
            
            if let alert = aps["alert"] as? NSString {
                //Do stuff
                part1 = alert as String
                debugPrint("Part 1: \(part1)")
                
                
                part2 = aps["ride_id"] as! String
                debugPrint("Part 2: \(part2)")
                
                part3 = aps["ride_status"] as! String
                debugPrint("Part 3: \(part3)")
                
                
                if part3 == "3"{
                self.dismiss(animated: true, completion: nil)
                }
                if part3 == "4"{
                    self.dismiss(animated: true, completion: nil)
                }
                
                
               // ApiManager.sharedInstance.protocolmain_Catagory = self
               // ApiManager.sharedInstance.customerSync1(RideId: part2, UserId: self.Userid!)
                
                
                
            }
            
        }
        
        
    }

    
   
}
