//
//  UpComingViewController.swift
//  Apporio Taxi
//
//  Created by Atul Jain on 21/12/17.
//  Copyright © 2017 apporio. All rights reserved.
//

import UIKit

class UpComingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, MainCategoryProtocol  {
    
    
    let imageUrl = API_URL.imagedomain
    
    
    
    @IBOutlet weak var newridetable: UITableView!
    
    var toastLabel : UILabel!
    
    var mydata: AllRides!
    
    var collectionsize = 0
    
    
    //  @IBOutlet var lblYourTrips: UILabel!
    
    
    let Userid = NsUserDekfaultManager.SingeltionInstance.getuserdetaild(key: NsUserDekfaultManager.Keyuserid)


    override func viewDidLoad() {
        super.viewDidLoad()
        
        GlobalVarible.cancelbtnvaluematch = "1"
        
        toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-300, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.white
        toastLabel.textColor = UIColor.black
        toastLabel.textAlignment = NSTextAlignment.center;
        self.view.addSubview(toastLabel)
        toastLabel.text =  "No Rides!!".localized
        
        toastLabel.isHidden = true
        
        ApiManager.sharedInstance.protocolmain_Catagory = self
        ApiManager.sharedInstance.ShowAllRides(UserId: self.Userid!)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if GlobalVarible.cancelbtnvaluematch == "2"{
            GlobalVarible.cancelbtnvaluematch  = ""
            ApiManager.sharedInstance.protocolmain_Catagory = self
            ApiManager.sharedInstance.ShowAllRides(UserId: self.Userid!)
            
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return collectionsize
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = newridetable.dequeueReusableCell(withIdentifier: "NewRide1", for: indexPath) as! NewYourRideTableViewCell
        
        
        cell.mainview.layer.shadowColor = UIColor.gray.cgColor
        cell.mainview.layer.shadowOpacity = 1
        cell.mainview.layer.cornerRadius = 5
        cell.mainview.layer.shadowOffset = CGSize(width:-0, height: 5)
        cell.mainview.layer.shadowRadius = 5
        
        
        
        cell.driverimage.layer.shadowColor = UIColor.gray.cgColor
        cell.driverimage.layer.shadowOpacity = 1
        cell.driverimage.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.driverimage.layer.shadowRadius = 2
        
        
        cell.orangecolorview.layer.cornerRadius = 5
        cell.orangecolorview.clipsToBounds = true
        
        if mydata.details![indexPath.row].rideMode == "2"{
            
            
            
            let checkstatus = mydata.details![indexPath.row].rentalRide?.bookingStatus
            
            
            if ((checkstatus == "15") || (checkstatus == "16") || (checkstatus == "19") || (checkstatus == "14") || (checkstatus == "18")) {
                
                
                
            }else{
            

            
            
            
            cell.normalfirstlocationview.isHidden = true
            cell.normalsecondlocationview.isHidden = true
            cell.rentallocationview.isHidden = false
            cell.normalredview.isHidden = true
            cell.normalgreenview.isHidden = true
            cell.rentalredview.isHidden = false
            cell.normalimageview.isHidden = true
            cell.rentalimageview.isHidden = false
            
            
            
         //   let checkstatus = mydata.details![indexPath.row].rentalRide!.bookingStatus
            
            cell.datelabel.text = (mydata.details![indexPath.row].rentalRide!.userBookingDateTime!)
            
            cell.rentallocationtext.text = mydata.details![indexPath.row].rentalRide!.pickupLocation
            
            cell.carnamelabel.text = mydata.details![indexPath.row].rentalRide!.carTypeName
            
            
            let cartypeimage = mydata.details![indexPath.row].rentalRide!
                .carTypeImage
            
            if cartypeimage == "" {
                
            }else{
                
                
                let newUrl = imageUrl + cartypeimage!
                //  let url = "http://apporio.co.uk/apporiotaxi/\(cartypeimage!)"
                debugPrint(newUrl)
                
                let url1 = NSURL(string: newUrl)
                cell.driverimage!.af_setImage(withURL:
                    url1! as URL,
                                              placeholderImage: UIImage(named: "dress"),
                                              filter: nil,
                                              imageTransition: .crossDissolve(1.0))
                
                
            }
            
            
            let pickuplat = Double(mydata.details![indexPath.row].rentalRide!.pickupLat!)!
            let pickuplong = Double(mydata.details![indexPath.row].rentalRide!.pickupLong!)!
            
            let phonewidth = Int(self.view.frame.width) + 100
            
            // &key=AIzaSyAwdw2gOgLTM_lAjEtVvIH87xHx3RTKEUQ
            let url11 = "https://maps.googleapis.com/maps/api/staticmap?center=\(pickuplat),\(pickuplong)&zoom=15&size=\(phonewidth)x120"
            
            let url1 = NSURL(string: url11)
            
            debugPrint(url11)
            
            cell.rentalmapimageview!.af_setImage(withURL:
                url1! as URL,
                                                 placeholderImage: UIImage(named: "dress"),
                                                 filter: nil,
                                                 imageTransition: .crossDissolve(1.0))
            
            
            
            
            
            
           /* if(checkstatus == "15"){
                //  cell.cancelimage.hidden = false
                //   cell.driverimage.image = UIImage(named: "cancel") as UIImage?
                cell.rentallocationtext.text = mydata.details![indexPath.row].rentalRide!.pickupLocation
                cell.statuslabel.text = "Ride Cancelled".localized
                // cell.secondlocation.text = mydata.details![indexPath.row].normalRide!.dropLocation
                
                
            }*/
            
            if (checkstatus == "10"){
                
                cell.statuslabel.text = "Ride Booked".localized
                //  cell.ongoinglabel.textColor = UIColor.greenColor()
                cell.rentallocationtext.text = mydata.details![indexPath.row].rentalRide!.pickupLocation
                //cell.secondlocation.text = mydata.details![indexPath.row].normalRide!.dropLocation
                
                
            }
            
            if (checkstatus == "11"){
                
                cell.statuslabel.text = "Ride Accepted".localized
                //   cell.ongoinglabel.textColor = UIColor.greenColor()
                cell.rentallocationtext.text = mydata.details![indexPath.row].rentalRide!.pickupLocation
                
                //  cell.secondlocation.text = mydata.details![indexPath.row].normalRide!.dropLocation
                
                
                
            }
          /*  if (checkstatus == "14"){
                
                cell.statuslabel.text = "Ride REJECTED".localized
                //  cell.ongoinglabel.textColor = UIColor.greenColor()
                cell.rentallocationtext.text = mydata.details![indexPath.row].rentalRide!.pickupLocation
                // cell.secondlocation.text = mydata.details![indexPath.row].normalRide!.dropLocation
                
                
            }*/
            if (checkstatus == "12"){
                
                cell.statuslabel.text = "Driver Arrived".localized
                
                cell.rentallocationtext.text = mydata.details![indexPath.row].rentalRide!.pickupLocation
                //  cell.secondlocation.text = mydata.details![indexPath.row].normalRide!.dropLocation
                
                
                
            }
            
            if (checkstatus == "13"){
                
                cell.statuslabel.text = "Ride Started".localized
                
                cell.rentallocationtext.text = mydata.details![indexPath.row].rentalRide!.pickupLocation
                
                
                //  cell.secondlocation.text = mydata.details![indexPath.row].normalRide!.dropLocation
                
            }
            
          /*  if (checkstatus == "16"){
                
                
                cell.pricelabel.text =  GlobalVarible.currencysymbol + " " + mydata.details![indexPath.row].rentalRide!.finalBillAmount!
                cell.rentallocationtext.text = mydata.details![indexPath.row].rentalRide!.pickupLocation
                
                //   cell.firstlocation.text = mydata.details![indexPath.row].rentalRide!.pickupLocation
                //   cell.secondlocation.text = mydata.details![indexPath.row].rentalRide!.dropLocation
                cell.statuslabel.text = "Ride Ended".localized
                //   cell.driverimage.image = UIImage(named: "completed") as UIImage?
                
                
                
            }
            
            if(checkstatus == "19"){
                //  cell.cancelimage.hidden = false
                //   cell.driverimage.image = UIImage(named: "cancel") as UIImage?
                cell.rentallocationtext.text = mydata.details![indexPath.row].rentalRide!.pickupLocation
                cell.statuslabel.text = "Ride Cancelled by Admin".localized
                // cell.secondlocation.text = mydata.details![indexPath.row].normalRide!.dropLocation
                
                
            }*/
            
            
            if(checkstatus == "22"){
                
                cell.rentallocationtext.text = mydata.details![indexPath.row].rentalRide!.pickupLocation
                cell.statuslabel.text = "Allotted to driver".localized
            }

            
            
            }
            
            
            
            
        }else{
            
            
            let checkstatus = mydata.details![indexPath.row].normalRide!.rideStatus
            
            
            
            if ((checkstatus == "2") || (checkstatus == "7") || (checkstatus == "9") || (checkstatus == "17") || (checkstatus == "4") ) {
                
                
                
            }else{
            
            
            
            cell.normalfirstlocationview.isHidden = false
            cell.normalsecondlocationview.isHidden = false
            cell.rentallocationview.isHidden = true
            cell.normalredview.isHidden = false
            cell.normalgreenview.isHidden = false
            cell.rentalredview.isHidden = true
            cell.normalimageview.isHidden = false
            cell.rentalimageview.isHidden = true
            
            
            
           
            
            cell.datelabel.text = (mydata.details![indexPath.row].normalRide!.rideDate!) + "," + (mydata.details![indexPath.row].normalRide!.rideTime!)
            cell.firstlocation.text = mydata.details![indexPath.row].normalRide!.pickupLocation
            
            cell.carnamelabel.text = mydata.details![indexPath.row].normalRide!.carTypeName
            
            
            let cartypeimage = mydata.details![indexPath.row].normalRide!
                .carTypeImage
            
            if cartypeimage == "" {
                
            }else{
                
                
                let newUrl = imageUrl + cartypeimage!
                //  let url = "http://apporio.co.uk/apporiotaxi/\(cartypeimage!)"
                debugPrint(newUrl)
                
                let url1 = NSURL(string: newUrl)
                cell.driverimage!.af_setImage(withURL:
                    url1! as URL,
                                              placeholderImage: UIImage(named: "dress"),
                                              filter: nil,
                                              imageTransition: .crossDissolve(1.0))
                
                
            }
            
            
            let pickuplat = Double(mydata.details![indexPath.row].normalRide!.pickupLat!)!
            let pickuplong = Double(mydata.details![indexPath.row].normalRide!.pickupLong!)!
            
            let phonewidth = Int(self.view.frame.width) + 100
            
            // &key=AIzaSyAwdw2gOgLTM_lAjEtVvIH87xHx3RTKEUQ
            let url11 = "https://maps.googleapis.com/maps/api/staticmap?center=\(pickuplat),\(pickuplong)&zoom=15&size=\(phonewidth/2)x120"
            
            let url1 = NSURL(string: url11)
            
            debugPrint(url11)
            
            cell.firstmapimageview!.af_setImage(withURL:
                url1! as URL,
                                                placeholderImage: UIImage(named: "dress"),
                                                filter: nil,
                                                imageTransition: .crossDissolve(1.0))
            
            
            let dropuplat = Double(mydata.details![indexPath.row].normalRide!.dropLat!)!
            let dropuplong = Double(mydata.details![indexPath.row].normalRide!.dropLong!)!
            
            
            
            let url22 = "https://maps.googleapis.com/maps/api/staticmap?center=\(dropuplat),\(dropuplong)&zoom=15&size=\(phonewidth/2)x120"
            
            debugPrint(url22)
            let url2 = NSURL(string: url22)
            cell.secondimageview!.af_setImage(withURL:
                url2! as URL,
                                              placeholderImage: UIImage(named: "dress"),
                                              filter: nil,
                                              imageTransition: .crossDissolve(1.0))
            
            
            
            
            
            
            
          /*  if(checkstatus == "2"){
                //  cell.cancelimage.hidden = false
                //   cell.driverimage.image = UIImage(named: "cancel") as UIImage?
                cell.firstlocation.text = mydata.details![indexPath.row].normalRide!.pickupLocation
                cell.statuslabel.text = "Ride Cancelled".localized
                cell.secondlocation.text = mydata.details![indexPath.row].normalRide!.dropLocation
                
                
            }*/
            
            if (checkstatus == "1"){
                
                cell.statuslabel.text = "Ride Booked".localized
                //  cell.ongoinglabel.textColor = UIColor.greenColor()
                cell.firstlocation.text = mydata.details![indexPath.row].normalRide!.pickupLocation
                cell.secondlocation.text = mydata.details![indexPath.row].normalRide!.dropLocation
                
                
            }
            
            if (checkstatus == "3"){
                
                cell.statuslabel.text = "Ride Accepted".localized
                //   cell.ongoinglabel.textColor = UIColor.greenColor()
                cell.firstlocation.text = mydata.details![indexPath.row].normalRide!.pickupLocation
                
                cell.secondlocation.text = mydata.details![indexPath.row].normalRide!.dropLocation
                
                
                
            }
            if (checkstatus == "4"){
                
                cell.statuslabel.text = "Ride REJECTED".localized
                //  cell.ongoinglabel.textColor = UIColor.greenColor()
                cell.firstlocation.text = mydata.details![indexPath.row].normalRide!.pickupLocation
                cell.secondlocation.text = mydata.details![indexPath.row].normalRide!.dropLocation
                
                
            }
            if (checkstatus == "5"){
                
                cell.statuslabel.text = "Driver Arrived".localized
                
                cell.firstlocation.text = mydata.details![indexPath.row].normalRide!.pickupLocation
                cell.secondlocation.text = mydata.details![indexPath.row].normalRide!.dropLocation
                
                
                
            }
            
            if (checkstatus == "6"){
                
                cell.statuslabel.text = "Ride Started".localized
                
                cell.firstlocation.text = mydata.details![indexPath.row].normalRide!.pickupLocation
                
                
                cell.secondlocation.text = mydata.details![indexPath.row].normalRide!.dropLocation
                
            }
            
          /*  if (checkstatus == "7"){
                
                cell.pricelabel.text =  GlobalVarible.currencysymbol + " " + mydata.details![indexPath.row].normalRide!.totalAmount!
                cell.firstlocation.text = mydata.details![indexPath.row].normalRide!.pickupLocation
                cell.secondlocation.text = mydata.details![indexPath.row].normalRide!.dropLocation
                cell.statuslabel.text = "Ride Ended".localized
                //   cell.driverimage.image = UIImage(named: "completed") as UIImage?
                
                
                
            }*/
            
            if (checkstatus == "8"){
                cell.statuslabel.text = "Booked Ride For Later".localized
                cell.firstlocation.text = mydata.details![indexPath.row].normalRide!.pickupLocation
                cell.secondlocation.text = mydata.details![indexPath.row].normalRide!.dropLocation
                
                
            }
            
           /* if (checkstatus == "9"){
                cell.statuslabel.text = "Ride Cancelled".localized
                
                //   cell.driverimage.image = UIImage(named: "cancel") as UIImage?
                cell.firstlocation.text = mydata.details![indexPath.row].normalRide!.pickupLocation
                cell.secondlocation.text = mydata.details![indexPath.row].normalRide!.dropLocation
                
                
                
            }
            
            if (checkstatus == "17"){
                cell.statuslabel.text = "Ride Cancelled by Admin".localized
                
                //   cell.driverimage.image = UIImage(named: "cancel") as UIImage?
                cell.firstlocation.text = mydata.details![indexPath.row].normalRide!.pickupLocation
                cell.secondlocation.text = mydata.details![indexPath.row].normalRide!.dropLocation
                
                
                
            }*/
            
            if(checkstatus == "22"){
                //  cell.cancelimage.hidden = false
                //   cell.driverimage.image = UIImage(named: "cancel") as UIImage?
                cell.firstlocation.text = mydata.details![indexPath.row].normalRide!.pickupLocation
                cell.statuslabel.text = "Allotted to driver".localized
                cell.secondlocation.text = mydata.details![indexPath.row].normalRide!.dropLocation
                
                
            }

            
            
            }
            
        }
        
        
        
        
        
        
        return cell
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView,estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if mydata.details![indexPath.row].rideMode == "2"{
            
            let checkstatus = mydata.details![indexPath.row].rentalRide?.bookingStatus
            
            
            if ((checkstatus == "15") || (checkstatus == "16") || (checkstatus == "19") || (checkstatus == "14") || (checkstatus == "18")) {
                
                return 0
                
            }else{
                return 225
            }
            
            
        }else{
            
            let checkstatus = mydata.details![indexPath.row].normalRide!.rideStatus
            
            
            if ((checkstatus == "2") || (checkstatus == "7") || (checkstatus == "9") || (checkstatus == "17") || (checkstatus == "4")) {
                
                return 0
                
                
            }else{
                
                
                return 225
                
            }
            
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if mydata.details![indexPath.row].rideMode == "2"{
            
            let checkstatus = mydata.details![indexPath.row].rentalRide?.bookingStatus
            
            
            if ((checkstatus == "15") || (checkstatus == "16") || (checkstatus == "19") || (checkstatus == "14") || (checkstatus == "18")) {
                return 0
            }else{
                
                return 225
            }
            
            
        }else{
            
            let checkstatus = mydata.details![indexPath.row].normalRide!.rideStatus
            
            
            if ((checkstatus == "2") || (checkstatus == "7") || (checkstatus == "9") || (checkstatus == "17") || (checkstatus == "4") ) {
                
                return 0
                
                
                
            }else{
                return 225
                
            }
            
        }
        return 0
    }
    
    

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        newridetable.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        debugPrint("Row: \(row)")
        
        
        var value = ""
        var datevalue = ""
        
        var rideidvalue = ""
        
        var ridemodevalue = ""
        
        if mydata.details![indexPath.row].rideMode == "2"{
            
            ridemodevalue = "2"
            
            value = mydata.details![indexPath.row].rentalRide!.bookingStatus!
            
            datevalue = mydata.details![indexPath.row].rentalRide!.userBookingDateTime!
            
            rideidvalue = mydata.details![indexPath.row].rentalRide!.rentalBookingId!
            
            
        }else{
            
            ridemodevalue = "1"
            
            value = mydata.details![indexPath.row].normalRide!.rideStatus!
            
            datevalue = mydata.details![indexPath.row].normalRide!.rideDate! + "  " + mydata.details![indexPath.row].normalRide!.rideTime!
            
            rideidvalue = mydata.details![indexPath.row].normalRide!.rideId!
            
        }
        
        debugPrint(value)
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let fulldetailsviewcontroller = storyBoard.instantiateViewController(withIdentifier: "FullDetailsViewController") as! FullDetailsViewController
        fulldetailsviewcontroller.ridestausvalue = value
        fulldetailsviewcontroller.datetimedata = datevalue
        fulldetailsviewcontroller.rideid = rideidvalue
        fulldetailsviewcontroller.ridemode = ridemodevalue
        
        self.present(fulldetailsviewcontroller, animated:true, completion:nil)
        
        
        
        /*  let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
         let fulldetailsViewController = storyBoard.instantiateViewController(withIdentifier: "
         FullDetailsViewController") as! FullDetailsViewController
         fulldetailsViewController.ridestausvalue = value!
         fulldetailsViewController.datetimedata = datevalue
         fulldetailsViewController.rideid = rideidvalue!
         self.presentViewController(fulldetailsViewController, animated:true, completion:nil)*/
        
        
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
        
        if(GlobalVarible.RideResult == 0){
            
            toastLabel.isHidden = false
            newridetable.isHidden = true
            
            
        }else{
            
            toastLabel.isHidden = true
            newridetable.isHidden = false
            
            mydata = data as! AllRides
            
            if(mydata.status == 0){
                collectionsize = 0
                
            }else{
                collectionsize = (mydata.details?.count)!
                
            }
            
            newridetable.reloadData()
            
        }
        
        
    }
    


    

   
}
