//
//  RatingViewController.swift
//  TaxiUser
//
//  Created by AppOrio on 25/05/17.
//  Copyright © 2017 apporio. All rights reserved.
//

import UIKit
import StarryStars
import SwiftyJSON

class RatingViewController: UIViewController,RatingViewDelegate,MainCategoryProtocol {
    
    @IBOutlet weak var donebtn: UIButton!
    
    @IBOutlet weak var userratingview: RatingView!
    
    var rentalratecustomerdata: RentalRateCustomerModel!
    
    
    @IBOutlet weak var ratingtextlabl: UILabel!
    
    
    @IBOutlet weak var commentifanytextlbl: UILabel!
    
    @IBOutlet weak var commenttext: UITextView!
    
    @IBOutlet weak var commentview: UIView!
    
    @IBOutlet weak var innerview: UIView!
    
    @IBOutlet weak var outerratingview: UIView!
    
   
    
   let Userid = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyuserid)
    var ratingStar = ""
    
    let imageUrl = API_URL.imagedomain
    
    var movefrom = ""
    
    var driverid = ""
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        ratingtextlabl.text = "RATING".localized
        commentifanytextlbl.text = "Comment(if any)".localized
        donebtn.setTitle("Done".localized, for: UIControlState.normal)
        
        
        self.donebtn.layer.borderWidth = 1.0
        self.donebtn.layer.cornerRadius = 4
        self.donebtn.layer.backgroundColor = UIColor.lightGray.cgColor
        
        
        self.commentview.layer.borderWidth = 1.0
        self.commentview.layer.cornerRadius = 4
        
        
        
     //   outerratingview.layer.borderWidth = 1.0
     //   outerratingview.layer.cornerRadius = 4
     //   innerview.layer.cornerRadius = 5
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        userratingview.editable = true
        userratingview.delegate = self


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ratingView(_ ratingView: RatingView, didChangeRating newRating: Float) {
        debugPrint("newRating: \(newRating)")
        let rating = newRating
        // var  ratingValue = String(rating)
        ratingStar = String(rating)
        GlobalVarible.RatingValue =  String(rating)
        
    }
    
    
    @IBAction func donebtn(_ sender: Any) {
        
        GlobalVarible.UserDropLocationText = "No drop off point".localized
        GlobalVarible.UserDropLat = 0.0
        GlobalVarible.UserDropLng = 0.0
        
        if(movefrom == "RentalReciept"){
        
        ApiManager.sharedInstance.protocolmain_Catagory = self
        ApiManager.sharedInstance.RentalRatingApi(RentalBookindId: GlobalVarible.RideId, RatingValue: GlobalVarible.RatingValue, DriverId: self.driverid, UserId: self.Userid!,Comment: commenttext.text!)
            
        }else{
        
        ApiManager.sharedInstance.protocolmain_Catagory = self
        ApiManager.sharedInstance.RatingSubmitbtn(UserId: Userid!, DriverId: GlobalVarible.DRIVERID , RatingStar: ratingStar,RideId: GlobalVarible.RideId,Comment: commenttext.text!)
            
        }
    }
    
    
    func showalert(message:String)  {
        
        DispatchQueue.main.async(execute: {
            
            let alertController = UIAlertController(title:  "Alert".localized, message:message, preferredStyle: .alert)
            
            
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
        
        
        if(GlobalVarible.Api == "NormalRating"){
        
        if(JSON(data)["result"] == 1){
            
            
          /*  let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
           
            appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)*/
            
            //self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            
            self.view.window?.rootViewController?.dismiss(animated: true, completion: {
                GlobalVarible.viewcontrollerself.viewDidLoad()
            })

            
          /*  let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextController: MapViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            
            if let window = self.view.window{
                window.rootViewController = nextController
            }*/
            
            
            
            
        }else{
            
            self.showalert(message: "Please Try Again!!".localized)
            
            
        }
            
        }
        
        if(GlobalVarible.Api == "rentalratecustomer"){
            
            self.rentalratecustomerdata = data as! RentalRateCustomerModel
            
            if(self.rentalratecustomerdata.status == 1){
                
                
                self.view.window?.rootViewController?.dismiss(animated: true, completion: {
                 GlobalVarible.viewcontrollerself.viewDidLoad()
                })
                
              // self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                
             /*   let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let nextController: MapViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                
                if let window = self.view.window{
                    window.rootViewController = nextController
                }*/
                
                
                
                
            }else{
                
                self.showalert(message: rentalratecustomerdata.message!)
                
                
            }
            
            
            
        }


    }
    

  
}
