//
//  RentalRecieptViewController.swift
//  TaxiUser
//
//  Created by AppOrio on 05/07/17.
//  Copyright © 2017 apporio. All rights reserved.
//

import UIKit
import SwiftyJSON


class RentalRecieptViewController: UIViewController,MainCategoryProtocol,PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate {
    
    
    
    @IBOutlet weak var makepaymentbtntext: UIButton!
    
    @IBOutlet weak var totalpayableamounttextlabel: UILabel!
    @IBOutlet weak var tripdetailstextlabel: UILabel!
    @IBOutlet weak var yourreciettextlabel: UILabel!
    
    @IBOutlet weak var initialmeterreadingtextlabel: UILabel!
    
    @IBOutlet weak var pleasereviewdetailstextlabel: UILabel!
    
    @IBOutlet weak var finalmeterreadingtextlabel: UILabel!
    
    @IBOutlet weak var distancetraveltextlabel: UILabel!
    
    @IBOutlet weak var bottomtotalpayableamounttextlabel: UILabel!
    
    @IBOutlet weak var billdetailstextlabel: UILabel!
    
    @IBOutlet weak var totalpricetextlabel: UILabel!
    
    @IBOutlet weak var totaltimetextlabel: UILabel!
    
    var rentalridefaredata: RentalRideFareModel!
    
    var rentalratecustomerdata: RentalRateCustomerModel!
    
    var paydata : PayCardModel!
    
    var rentaldata : RentalPaymentmodel!

    
     var userselectpaymentoption = ""
    
     var selectpaymentstatus = ""
    
    
    @IBOutlet weak var tripdetailsview: UIView!
    
    @IBOutlet weak var totalpayableamountview: UIView!
    
    @IBOutlet weak var bottomview: UIView!
    
    
    @IBOutlet weak var pickuplocationtext: UILabel!
    
    @IBOutlet weak var dropofflocationtext: UILabel!
    
    
    @IBOutlet weak var initialmeterreadingtext: UILabel!
    
    @IBOutlet weak var finalmeterreadingtext: UILabel!
    
    
    @IBOutlet weak var totalpaymenttextbold: UILabel!
    
    @IBOutlet weak var totaldistancetraveltext: UILabel!
    
    @IBOutlet weak var totaltimetext: UILabel!
    
    @IBOutlet weak var packageprice: UILabel!
    
    @IBOutlet weak var packagetext: UILabel!
    
    
    @IBOutlet weak var extradistanctraveltext: UILabel!
    
    @IBOutlet weak var extradistancetravelprice: UILabel!
    
    @IBOutlet weak var extraestimatedtimetext: UILabel!
    
    @IBOutlet weak var extraestimatedtimeprice: UILabel!
    
    @IBOutlet weak var totalprice: UILabel!
    
    
    @IBOutlet weak var couponappliedtext: UILabel!
    
    @IBOutlet weak var couponappliedprice: UILabel!
    
  //  @IBOutlet weak var ratingview: RatingView!
    
    @IBOutlet weak var totalpayableamount: UILabel!
    
    
    var i = 0
    
    var resultText = ""
    var payPalConfig = PayPalConfiguration()
    
    var environment:String = PayPalEnvironmentProduction {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    static let sharedInstance = RentalRecieptViewController()
    
    
    #if HAS_CARDIO
    // You should use the PayPal-iOS-SDK+card-Sample-App target to enable this setting.
    // For your apps, you will need to link to the libCardIO and dependent libraries. Please read the README.md
    // for more details.
    var acceptCreditCards: Bool = true {
    didSet {
    payPalConfig.acceptCreditCards = acceptCreditCards
    }
    }
    #else
    var acceptCreditCards: Bool = false {
        didSet {
            payPalConfig.acceptCreditCards = acceptCreditCards
        }
    }
    #endif
    
    

    
    
   var ratingStar = ""
    
    var  userid = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyuserid)
    
    var driverid = ""
    
    var currentrideid = ""
    
     var creditcardrideid = ""
    
    
    func viewSetup(){
        
        
        yourreciettextlabel.text = "YOUR RECEIPT".localized
        pleasereviewdetailstextlabel.text = "Please Review your reciept before making your payment".localized
        tripdetailstextlabel.text = "Trip Details".localized
        initialmeterreadingtextlabel.text = "Initial meter Reading".localized
        finalmeterreadingtextlabel.text = "Final meter Reading".localized
        totalpayableamounttextlabel.text = "Total Payable Amount".localized
        distancetraveltextlabel.text = "Distance Travel :".localized
        totaltimetextlabel.text = "Total Time :".localized
        billdetailstextlabel.text = "Bill Details :".localized
        totalpricetextlabel.text = "Total Price :".localized
        bottomtotalpayableamounttextlabel.text = "Total Payable Amount".localized
        makepaymentbtntext.setTitle("Make Payment".localized, for: UIControlState.normal)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewSetup()
        
        tripdetailsview.layer.shadowColor = UIColor.gray.cgColor
        tripdetailsview.layer.shadowOpacity = 1
        tripdetailsview.layer.shadowOffset = CGSize(width: 0, height: 3)
        tripdetailsview.layer.shadowRadius = 5
        
        totalpayableamountview.layer.shadowColor = UIColor.gray.cgColor
        totalpayableamountview.layer.shadowOpacity = 1
        totalpayableamountview.layer.shadowOffset = CGSize(width: 0, height: 3)
        totalpayableamountview.layer.shadowRadius = 5
        
        
        
        payPalConfig.acceptCreditCards = acceptCreditCards
        payPalConfig.merchantName = ""
        payPalConfig.merchantPrivacyPolicyURL = NSURL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full") as URL?
        payPalConfig.merchantUserAgreementURL = NSURL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")! as URL
        payPalConfig.languageOrLocale = NSLocale.preferredLanguages[0]
        
        payPalConfig.payPalShippingAddressOption = .payPal

       // ratingview.editable = true
       // ratingview.delegate = self
        
        ApiManager.sharedInstance.protocolmain_Catagory = self
        ApiManager.sharedInstance.RentalRideFare(RentalBookindId: currentrideid)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return 0
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        
        return cell
        
    }

    
    
   /* func ratingView(_ ratingView: RatingView, didChangeRating newRating: Float) {
        debugPrint("newRating: \(newRating)")
        let rating = newRating
        // var  ratingValue = String(rating)
        ratingStar = String(rating)
        GlobalVarible.RatingValue =  String(rating)
        
    }*/
    
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        debugPrint("PayPal Payment Cancelled")
        resultText = ""
        
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        debugPrint("PayPal Payment Success !")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            
            let data = JSON(completedPayment.confirmation)
            debugPrint(data)
            let datatoParse = PayPalModel(json: data)
            GlobalVarible.CreateTime =  (datatoParse.response?.createTime!)!
            GlobalVarible.State = (datatoParse.response?.state!)!
            GlobalVarible.PaypalId = (datatoParse.response?.internalIdentifier!)!
            GlobalVarible.Intent = (datatoParse.response?.intent!)!
            self.resultText = completedPayment.description
            
            ApiManager.sharedInstance.protocolmain_Catagory = self
            ApiManager.sharedInstance.RentalPaymentUrl(RentalBookindId: self.currentrideid, TotalAmount: GlobalVarible.TotalPayableamount, PaymentStatus: GlobalVarible.State)
            
          //  ApiManager.sharedInstance.ConfirmPayment(OrderId: self.donerideid, UserId: self.Userid!, PaymentId: GlobalVarible.PaypalId, PaymentMethod: "Paypal", PaymentPlatform: "Ios", PaymentAmount: GlobalVarible.TotalPayableamount, PaymentDate: GlobalVarible.CreateTime, PaymentStatus: GlobalVarible.State)
            // self.showSuccess()
        })
    }
    
    
    
    // MARK: Future Payments
    
    
    
    @IBAction func authorizeFuturePaymentsAction(sender: AnyObject) {
        let futurePaymentViewController = PayPalFuturePaymentViewController(configuration: payPalConfig, delegate: self)
        present(futurePaymentViewController!, animated: true, completion: nil)
    }
    
    
    
    
    func payPalFuturePaymentDidCancel(_ futurePaymentViewController: PayPalFuturePaymentViewController) {
        debugPrint("PayPal Future Payment Authorization Canceled")
        futurePaymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalFuturePaymentViewController(_ futurePaymentViewController: PayPalFuturePaymentViewController, didAuthorizeFuturePayment futurePaymentAuthorization: [AnyHashable : Any]) {
        debugPrint("PayPal Future Payment Authorization Success!")
        // send authorization to your server to get refresh token.
        futurePaymentViewController.dismiss(animated: true, completion: { () -> Void in
            self.resultText = futurePaymentAuthorization.description
            self.showSuccess()
        })
    }
    
    
    // MARK: Profile Sharing
    
    @IBAction func authorizeProfileSharingAction(sender: AnyObject) {
        let scopes = [kPayPalOAuth2ScopeOpenId, kPayPalOAuth2ScopeEmail, kPayPalOAuth2ScopeAddress, kPayPalOAuth2ScopePhone]
        let profileSharingViewController = PayPalProfileSharingViewController(scopeValues: NSSet(array: scopes) as Set<NSObject>, configuration: payPalConfig, delegate: self)
        present(profileSharingViewController!, animated: true, completion: nil)
    }
    // PayPalProfileSharingDelegate
    
    func payPalProfileSharingViewController(_ profileSharingViewController: PayPalProfileSharingViewController, userDidLogInWithAuthorization profileSharingAuthorization: [AnyHashable : Any]) {
        debugPrint("PayPal Profile Sharing Authorization Success!")
        
        // send authorization to your server
        
        profileSharingViewController.dismiss(animated: true, completion: { () -> Void in
            self.resultText = profileSharingAuthorization.description
            
            
            self.showSuccess()
        })
        
    }
    
    
    func userDidCancel(_ profileSharingViewController: PayPalProfileSharingViewController) {
        debugPrint("PayPal Profile Sharing Authorization Canceled")
        
        profileSharingViewController.dismiss(animated: true, completion: nil)
    }
    
    
    
    func showSuccess() {
        self.dismiss(animated: true, completion: nil)
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        UIView.setAnimationDelay(2.0)
        
        UIView.commitAnimations()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    

    
    
    @IBAction func submit_btn_click(_ sender: Any) {
        
        if(selectpaymentstatus == "0"){
            
            
            if(userselectpaymentoption == "1"){
                
                
                ApiManager.sharedInstance.protocolmain_Catagory = self
                ApiManager.sharedInstance.RentalPaymentUrl(RentalBookindId: self.currentrideid, TotalAmount: GlobalVarible.TotalPayableamount, PaymentStatus: "Done")
                
                
                
                
            }else if(userselectpaymentoption == "2"){
                
                let decimalTotalamount = NSDecimalNumber(string: GlobalVarible.TotalPayableamount)
                
                debugPrint(decimalTotalamount)
                
                let payment = PayPalPayment(amount: decimalTotalamount, currencyCode: "GBP", shortDescription: "Pay", intent: .sale)
                
                
                if (payment.processable) {
                    let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
                    present(paymentViewController!, animated: true, completion: nil)
                }
                else {
                    
                    debugPrint("Payment not processable: \(payment)")
                }
                
                
                
                
            }else if(userselectpaymentoption == "3"){
                
                ApiManager.sharedInstance.protocolmain_Catagory = self
                ApiManager.sharedInstance.PayPaymentCard(RideId: creditcardrideid, Amount: GlobalVarible.TotalPayableamount)
                
                
            }else if(userselectpaymentoption == "4"){
                
                
                ApiManager.sharedInstance.protocolmain_Catagory = self
                ApiManager.sharedInstance.RentalPaymentUrl(RentalBookindId: self.currentrideid, TotalAmount: GlobalVarible.TotalPayableamount, PaymentStatus: "Done")
                
                // ApiManager.sharedInstance.protocolmain_Catagory = self
                // ApiManager.sharedInstance.ConfirmPayment(OrderId: donerideid, UserId: Userid!, PaymentId: "1", PaymentMethod: "Wallet", PaymentPlatform: "Ios", PaymentAmount: GlobalVarible.TotalPayableamount, PaymentDate: GlobalVarible.CurrentDate, PaymentStatus: "Done")
                
                
            }

        }else{
        
            UserDefaults.standard.setValue("0", forKey:"firebaseride_status")
            GlobalVarible.checkRideId = "0"
            GlobalVarible.checkridestatus = "0"
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let newratingViewController = storyBoard.instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
            newratingViewController.movefrom = "RentalReciept"
            newratingViewController.driverid = self.driverid
            newratingViewController.modalPresentationStyle = .overCurrentContext
            self.present(newratingViewController, animated:true, completion:nil)

        
        
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
    
    
    func showalert1(message:String)  {
        
        DispatchQueue.main.async(execute: {
            
            let alertController = UIAlertController(title:  "Alert".localized, message:message, preferredStyle: .alert)
            
            
            let OKAction = UIAlertAction(title: "ok".localized, style: .default) { (action) in
                
                
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
        
        
        if(GlobalVarible.Api == "rentalridefare"){
            
            
            rentalridefaredata = data as! RentalRideFareModel
            
            
            if(rentalridefaredata.status == 1){
                
                currentrideid = (rentalridefaredata.details?.rentalBookingId)!
                
                driverid = (rentalridefaredata.details?.driverId)!
                
                 GlobalVarible.RideId = (rentalridefaredata.details?.rentalBookingId)!
                
                creditcardrideid = (rentalridefaredata.details?.rentalBookingId)!
                
                
                pickuplocationtext.text = rentalridefaredata.details?.beginLocation
                dropofflocationtext.text = rentalridefaredata.details?.endLocation
                initialmeterreadingtext.text = rentalridefaredata.details?.startMeterReading
                finalmeterreadingtext.text = rentalridefaredata.details?.endMeterReading
                
                
                GlobalVarible.TotalPayableamount = (rentalridefaredata.details?.finalBillAmount)!
                    
                totalpaymenttextbold.text = GlobalVarible.currencysymbol + " " + (rentalridefaredata.details?.finalBillAmount)!
                
                
                
                totaldistancetraveltext.text = (rentalridefaredata.details?.totalDistanceTravel)!
                totaltimetext.text = rentalridefaredata.details?.totalTimeTravel
                packagetext.text = "Package".localized + "(" + (rentalridefaredata.details?.rentalPackageDistance)! + " for " + (rentalridefaredata.details?.rentalPackageHours)! + " hrs.)"
                
                packageprice.text = GlobalVarible.currencysymbol + " " + (rentalridefaredata.details?.rentalPackagePrice)!
                
                extradistanctraveltext.text = "Extra Distance Travel".localized +  "(" + (rentalridefaredata.details?.extraDistanceTravel)! + " Km)"
                
                extradistancetravelprice.text = GlobalVarible.currencysymbol + " " + (rentalridefaredata.details?.extraDistanceTravelCharge)!
                
                extraestimatedtimetext.text = "Extra Estimated time".localized + "(" + (rentalridefaredata.details?.extraHoursTravel)! + "hrs.)"
                extraestimatedtimeprice.text = GlobalVarible.currencysymbol + " " + (rentalridefaredata.details?.extraHoursTravelCharge)!
                
                totalprice.text = GlobalVarible.currencysymbol + " " + (rentalridefaredata.details?.totalamount)!
                
                couponappliedtext.text = "Coupon Applied".localized + "( " + (rentalridefaredata.details?.couponcode)! + " )"
                
                couponappliedprice.text = GlobalVarible.currencysymbol + " " + (rentalridefaredata.details?.couponprice!)!
                
                totalpayableamount.text = GlobalVarible.currencysymbol + " " + (rentalridefaredata.details?.finalBillAmount)!
                
                 userselectpaymentoption = (rentalridefaredata.details?.paymentOptionId!)!
                
                
                   selectpaymentstatus = (rentalridefaredata.details?.paymentStatus)!
                
            }else{
                
                debugPrint("HelloRating")
                
            }
            

            
            
        }
        
        
        if(GlobalVarible.Api == "paycard"){
            paydata = data as! PayCardModel
            
            let completepaymentid = paydata.paymentId
            
            if(paydata.result == 1){
                
                ApiManager.sharedInstance.protocolmain_Catagory = self
                ApiManager.sharedInstance.RentalPaymentUrl(RentalBookindId: self.currentrideid, TotalAmount: GlobalVarible.TotalPayableamount, PaymentStatus: "Done")
                
                
                
            }else{
                
                self.showalert(message: paydata.msg!)
            }
            
            
            
        }
        

        
        if(GlobalVarible.Api == "rentalpayment"){
            
            rentaldata = data as! RentalPaymentmodel
            
            if(rentaldata.status == 1){
                // makepayment.userInteractionEnabled = false
                // Viewinvoice.userInteractionEnabled = true
                
                
                UserDefaults.standard.setValue("0", forKey:"firebaseride_status")
                GlobalVarible.checkRideId = "0"
                GlobalVarible.checkridestatus = "0"
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let newratingViewController = storyBoard.instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
                newratingViewController.movefrom = "RentalReciept"
                newratingViewController.driverid = self.driverid
                newratingViewController.modalPresentationStyle = .overCurrentContext
                self.present(newratingViewController, animated:true, completion:nil)
                
                
            }else{
                               
                self.showalert1(message: rentaldata.message!)
                
                
                
            }
            
            
        }

        
        
        

    

    }

 

}
