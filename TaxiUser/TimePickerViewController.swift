//
//  TimePickerViewController.swift
//  TaxiUser
//
//  Created by AppOrio on 29/05/17.
//  Copyright © 2017 apporio. All rights reserved.
//

import UIKit

class TimePickerViewController: UIViewController,MainCategoryProtocol {
    
    @IBOutlet weak var selectdatetimetext: UILabel!
    
    var matchstring = ""
    
    let Userid = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyuserid)
    
    var renttypeid = ""
    
    var cartypeid = ""
    
    var rentalbooklaterdata: RentalBookLaterModel!
    
    
    @IBOutlet weak var cancelbtntextlabel: UIButton!
    @IBOutlet weak var donebtntextlabel: UIButton!
    @IBOutlet weak var selectdatetimetextlabel: UILabel!
    
    @IBOutlet weak var datepick: UIDatePicker!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = Date()
        
        selectdatetimetext.text = "Select Date & Time".localized
        donebtntextlabel.setTitle("Done".localized, for: .normal)
        cancelbtntextlabel.setTitle("Cancel".localized, for: .normal)
       
       // let newdate = date.addingTimeInterval(7200)
        let newdate = date.addingTimeInterval(300)
        debugPrint(newdate)
        datepick.minimumDate = newdate
        
        //let formatter = DateFormatter()
      //  datepick.minimumDate = date
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func changedatevaluebtn(_ sender: Any) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy"
        let strDate = formatter.string(from: datepick.date)
        debugPrint(strDate)
        
        
        
        formatter.dateFormat = "HH:mm:ss"
        let time = formatter.string(from: datepick.date)
        debugPrint(time)

        selectdatetimetext.text = strDate + " " + time
        
        
    }
    
    
    
    @IBAction func donebtn(_ sender: Any) {
        
        
        if matchstring == "FromRental"{
            
            
            let formatter = DateFormatter()
           // formatter.dateFormat = "E, dd MMM yyyy"
            formatter.dateFormat = "yyyy-MM-dd"
            let strDate = formatter.string(from: datepick.date)
            debugPrint(strDate)
            
            
            
            formatter.dateFormat = "HH:mm:ss"
            let time = formatter.string(from: datepick.date)
            debugPrint(time)
            
            GlobalVarible.SelectDate = strDate
            GlobalVarible.SelectTime = time
            
            
           /* let dic=[ RideNowUrl1:"\("2")",
                RideNowUrl2:"\("2")",
                RideNowUrl3:"\(self.Userid!)",
                RideNowUrl4:"\(GlobalVarible.CouponCode)",
                RideNowUrl5:"\(GlobalVarible.PickUpLat)",
                RideNowUrl6:"\(GlobalVarible.PickUpLng)",
                RideNowUrl7:"\(GlobalVarible.Pickuptext)",
                RideNowUrl8:"\("")",
                RideNowUrl9:"\("")",
                RideNowUrl10:"\("")",
                RideNowUrl11:"\(cartypeid)",
                RideNowUrl12:"\(GlobalVarible.CardId)",
                RideNowUrl13:"\(GlobalVarible.PaymentOptionId)",
                RideNowUrl14:"\(renttypeid)",
                RideNowUrl15:"\(GlobalVarible.SelectDate)",
                RideNowUrl16:"\(GlobalVarible.SelectTime)",
                RideNowUrl17:"\(GlobalVarible.languageid)"
                
                
            ]
            debugPrint(dic)
            
            ApiManager.sharedInstance.protocolmain_Catagory = self
            ApiManager.sharedInstance.ConfirmRide(dictonary: dic as NSDictionary, url: RideNowUrl)*/
            
            
            
            ApiManager.sharedInstance.protocolmain_Catagory = self
             ApiManager.sharedInstance.RentalBookRideLater(USERID: self.Userid!, USERCURRENTLAT: GlobalVarible.PickUpLat, USERCURRENTLONG: GlobalVarible.PickUpLng, CURRENTADDRESS: GlobalVarible.Pickuptext, CARTYPEID: cartypeid, RentCardId: renttypeid, SELECTTIME: GlobalVarible.SelectTime, SELECTDATE: GlobalVarible.SelectDate,COUPONCODE: GlobalVarible.CouponCode,PaymentOPtionId: GlobalVarible.PaymentOptionId)
            
            
            self.matchstring = ""
            
        } else{
            
            
            let formatter = DateFormatter()
            //formatter.dateFormat = "E, dd MMM yyyy"
            formatter.dateFormat = "yyyy/MM/dd"
            let strDate = formatter.string(from: datepick.date)
            debugPrint(strDate)
            
            
            
            formatter.dateFormat = "HH:mm:ss"
            let time = formatter.string(from: datepick.date)
            debugPrint(time)
            
            GlobalVarible.SelectDate = strDate
            GlobalVarible.SelectTime = time
            
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let ridelaterviewcontroller = storyBoard.instantiateViewController(withIdentifier: "RideLaterViewController") as! RideLaterViewController
            ridelaterviewcontroller.modalPresentationStyle = .overCurrentContext
            //  paymentviewcontroller.modalPresentationStyle = .Popover
            self.present(ridelaterviewcontroller, animated:true, completion:nil)
            
        }
        
        
    }
    
    
    @IBAction func Cancelbtn(_ sender: Any) {
        
        GlobalVarible.SelectDate = ""
        
        GlobalVarible.SelectTime = ""
        
        self.dismiss(animated: true, completion: nil)

        
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
    
    
    func showalert1(message:String)  {
        
        DispatchQueue.main.async(execute: {
            
            let alertController = UIAlertController(title:   "Alert".localized, message:message, preferredStyle: .alert)
            
            
            let OKAction = UIAlertAction(title: "ok".localized, style: .default) { (action) in
                
              /*  let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let revealViewController:MapViewController = storyBoard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                
                self.present(revealViewController, animated:true, completion:nil)*/
                
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let nextController: MapViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                
                if let window = self.view.window{
                    window.rootViewController = nextController
                }
                

                
                
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
        
        
        if(GlobalVarible.Api == "rentalconfirmridebooklater"){
            
            
             rentalbooklaterdata = data as! RentalBookLaterModel
            
           // confirmridedata = data as! ConfirmRideModel
            
            
            if(rentalbooklaterdata.status == 1){
                
                self.showalert1(message: "Your ride has been schedule.Driver details will be shared 15 min before your pickup time.".localized)
                
                
                
            }else{
                
                self.showalert(message: rentalbooklaterdata.message!)
                
            }
            
            
            
            
            
        }
        
        
    }
    
    


   

}
